# Dockerizer

`{dockerizer}` is a small package to take analyses written on your machine and write/build dockerfiles/images so that they can be run by someone else.

## How To Use Dockerize

`{dockerizer}` requires that your analysis project uses [`{renv}`](https://rstudio.github.io/renv/articles/renv.html) to manage packages.

In your analysis folder, run `write_dockerfile()` to create a dockerfile with the appropriate arguments for your project.  See `?write_dockerfile` for what arguments can be specified.

Once the dockerfile is written, you can edit the file as you see fit or use the `build` and `image_name` arguments to build the image upon being written.  

Once the image is built, the easiest way to run the container is 

```bash
docker run -p 8787:8787 -v $(pwd):/home/rstudio -e USER={username} -e PASSWORD={password} --name {container_name} -d {image_name}
```

You can then connect to an rstudio server at `https://localhost:8787/` (or whatever port you specified in your `docker run` command).  From there, you will need to install your packages using `renv::restore()`.
