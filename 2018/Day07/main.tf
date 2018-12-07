variable input_data {
  description = "The input for our solver in string format"
  type        = "string"

  default = <<EOF
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
EOF
}

locals {
  # The newline at the end before the keyword EOF is VERY IMPORTANT

  input_as_pair = [
    "${split("\n", replace(var.input_data, "/Step (.) must be .* step (.) can begin./", "$1$2"))}",
  ]

  intput_pair_joined = "${join(",", local.input_as_pair)}"

  # Some constants that we use
  all_characters         = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  all_characters_as_list = "${split("", local.all_characters)}"
  result_file            = "result"

  # Type as well as name of the node in the final graph that we want to construct using our compute module
  node_prefix       = "resource null_resource char_"
  dependency_prefix = "${replace(replace(local.node_prefix, "/^[^ ]+ /", ""), " ", ".")}"
}

# Figure out the dependency for each character
data null_data_source dependency {
  count = "${length(local.all_characters)}"

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
resource local_file compute_module {
  filename = "tan-local/main.tf"

  content = "${join(
    "\n",
    data.template_file.compute_module_snippet.*.rendered
  )}"
}

data template_file compute_module_snippet {
  count = "${length(local.all_characters)}"

  # List of variables here is set up in dependency
  # note that indent does NOT work
  template = <<EOF
${local.node_prefix}$${lower(char)} {
  depends_on = [
    $${join(",\n    ", formatlist("\"${local.dependency_prefix}%s\"", split("", lower(dependency_as_string))))}
  ]
  provisioner local-exec {
    command = "echo $${upper(char)} >> ${local.result_file}"
  }
}
EOF

  vars = "${data.null_data_source.dependency.*.outputs[count.index]}"
}
