# Day07

This directory contains **NOT THE SOLUTION** to day 7 problem, rather, I wanted
to have some fun with the Terraform Graph engine and explore it a bit more.

The problem of day 7 is, essentially, to construct and walk
a [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph). As a DevOps, most
of the time I work with Terraform, which internally is just [a graph engine
capable of constructing and walking DAG](https://www.youtube.com/watch?v=Ce3RNfRbdZ0) as well.
So, instead of solving the problem, I decided to have some fun with it.

## Idea

Basically, we want to construct a Terraform source code which has explicit
dependency declared base on the input data, something as follow:

```tf
resource null_resource char_a {
  depends_on = [
    "null_resource.char_l"
  ]
}

resource null_resource char_l {
  depends_on = [
  ]
}
```

Using this code, we can construct DAG with Terraform.

> Unfortunately, internally, when multiple different vertices in the DAG of
Terraform has their dependents cleared out, Terraform will walk those in
a random order, rather than in alphabetical order (as the problem statement
requires), so **using Terraform to print out the answer to the problem can be
complicated**

Of course, we would want to use the real input, rather than any pre-processed
one (ie. we will somehow trick Terraform into generating the source code for
us).

## Generating the graph source code

Since Terraform does not allow using
[interpolation](https://www.terraform.io/docs/configuration/interpolation.html)
in it `depends_on` parameter. In other words, the `depends_on` has to be
static and clearly declared in the code, rather than any `${....}`

As such, I decided to use a Terraform code to generate the _graphing code_

This process is a bit strange, but with Makefile, things might get easier

## How to use this

Well, essentially, please make sure you have `terraform`, `make` and a program
to manipulate your clipboard (`pbcopy` in MacOS case - and it's pre-installed).

Then, you can just execute `make`, the
[DOT](https://en.wikipedia.org/wiki/DOT_(graph_description_language) source code
of the DAG will then be available in your clipboard

Head over to [http://www.webgraphviz.com/](http://www.webgraphviz.com/), paste
it in and you can then start exploring your graph

**Please note that this is a dependency graph, so the direction of each edge is
the reverse of the _execution order_ of the _instruction_**

You can modify `real_input.tfvars` to specify your input data.

## Getting fancy

[Blast radius] is a fun tool to explore the graph of Terraform.

When you run `make`, we are (as mentioned before) rendering a `main.tf` file
under the directory `compute`, which has the graph defined in it.

You can use Blast Radius to draw the graph and then explore it with your
browser.

Simply `cd` into `compute/`, and then launch a Docker container with Blast
Radius

```bash
docker run --cap-add=SYS_ADMIN -it --rm -p 5000:5000 -v $(pwd):/workdir:ro 28mm/blast-radius
```

Then you can open your browser to [localhost:5000](http://localhost:5000) to
start exploring
