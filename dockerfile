# Use the rocker/rstudio base image
FROM rocker/rstudio:latest


# Install system dependencies
RUN apt-get update -qq && apt-get -y --no-install-recommends install libcurl4-openssl-dev libssl-dev make zlib1g-dev libglpk-dev libxml2-dev pandoc libfreetype6-dev libjpeg-dev libpng-dev libtiff-dev libicu-dev libfontconfig1-dev libfribidi-dev libharfbuzz-dev


# Set the CRAN repository
RUN echo 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/latest"))' > /usr/local/lib/R/etc/Rprofile.site

# Copy the analysis directory and renv.lock file to the container
COPY . /home/rstudio/.
COPY renv.lock /home/rstudio/renv.lock

# Set the working directory to the analysis folder
WORKDIR /home/rstudio/

# Install renv
RUN R -e "install.packages('renv')"

# Expose the RStudio Server port
EXPOSE 8787
# Change ownership of the analysis directory to the rstudio user
RUN chown -R rstudio:rstudio /home/rstudio

# Set up environment variables for RStudio
ENV USER rstudio
ENV PASSWORD rstudio
