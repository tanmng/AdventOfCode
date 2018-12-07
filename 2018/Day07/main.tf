locals {
  # The newline at the end before the keyword EOF is VERY IMPORTANT
  input = <<EOF
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
EOF

  input_as_pair = [
    "${split("\n", replace(local.input, "/Step (.) must be .* step (.) can begin./", "$1$2"))}",
  ]

  intput_pair_joined = "${join(",", local.input_as_pair)}"

  # Some constants that we use
  all_characters         = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  all_characters_as_list = "${split("", local.all_characters)}"
}

# Figure out the dependency for each character
data null_data_source dependency {
  # count = "${length(local.all_characters)}"
  count = 6

  inputs {
    char                = "${element(local.all_characters_as_list, count.index)}"
    char_dependency_raw = "${replace(local.intput_pair_joined, "/.[^${element(local.all_characters_as_list, count.index)}],/", "")}"

    dependency_as_string = "${replace(
      replace(local.intput_pair_joined, "/.[^${element(local.all_characters_as_list, count.index)}],/", ""),
      "${element(local.all_characters_as_list, count.index)},",
      ""
    )}"
  }
}

# Render the module file - Unfortunately Terraform doesn't allow interpolation in 
# `depends_on` variable, as such we have to try to render it and then reuse
# Quite a strange idea, but it works, so whatever
resource local_file calculation_module {
  filename = "module.done"

  content = "${join(
    "\n",
    data.template_file.calculation_module_snippet.*.rendered
  )}"
}

data template_file calculation_module_snippet {
  count = 6

  # List of variables here is set up in dependency
  template = <<EOF
data null_data_source char_$${lower(char)} {
  inputs {
    char = "$${upper(char)}"
  }
}
EOF

  vars = "${data.null_data_source.dependency.*.outputs[count.index]}"
}

/* data null_data_source step { */
/*   count = "${length(local.all_characters)}" */

/*   inputs { */
/*     dependency = "${data.null_data_source.*.dependency" */
/*   } */
/* } */

resource local_file output_file {
  content  = "${jsonencode(data.null_data_source.dependency.*.outputs[0])}"
  filename = "foo.json"
}
