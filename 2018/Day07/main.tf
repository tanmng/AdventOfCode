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

  # Some constants that we use
  all_characters         = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  all_characters_as_list = "${split("", local.all_characters)}"
}

# Figure out the dependency for each character
data null_data_source dependency {
  # count = "${length(local.all_characters)}"
  count = 1

  inputs {
    char            = "${element(local.all_characters_as_list, count.index)}"
    join            = "${join(",", local.input_as_pair)}"
    char_dependency = "${replace(join(",", local.input_as_pair), "/.[^${element(local.all_characters_as_list, count.index)}],/", "")}"
  }
}

/* data null_data_source step { */
/*   count = "${length(local.all_characters)}" */

/*   inputs { */
/*     dependency = "${data.null_data_source.*.dependency" */
/*   } */
/* } */

resource local_file output_file {
  content  = "${jsonencode(data.null_data_source.dependency.*.outputs)}"
  filename = "foo.json"
}
