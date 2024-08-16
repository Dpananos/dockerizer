# Dockerizer

`{dockerizer}` is a small package to take analyses written on your machine and write/build dockerfiles/containers so that they can be run by someone else.

Ideally, your analysis lives in a directory (e.g. `path/to/my/analysis`).  You can then call `dockerize` with a few options to write a dockerfile and optionally build the container.  Hopefully you're using `{renv}` to manage packages.  If so, `{dockerizer}` will read in the packages from your `renv.lock` file and construct a dockerfile with the right system dependencies.  

If you run

```
dir <- 'path/to/my/analysis/'

write_dockerfile(analysis_dir = dir, port = '8787')
```

then `write_dockerfile` will create `path/to/my/analysis/dockerfile`.  Passing `build=TRUE` and `container_name="my_container_name"` will build the container.  Once built, you can access rstudio server at `https://localhost:8787/` and run your analysis.  


