# Use a specific, recent version of Ubuntu
FROM ubuntu:22.04

# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install Python and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    iproute2 \
    iputils-ping \
    traceroute \
    && apt-get clean

# Install Flask using pip
RUN pip3 install Flask requests

# Set the working directory in the container
WORKDIR /app

# Copy the Flask app file into the container
COPY app.py /app/

# Expose port 8080 to the outside world
EXPOSE 8080

# Entry point script for network configuration and starting the Flask app
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]