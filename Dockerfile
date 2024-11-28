# Step 1: Build stage
FROM golang:1.23 as build

WORKDIR /app

# Copy go.mod and download dependencies
COPY go.mod .
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application into an executable named "main"
RUN go build -o main

# Step 2: Final image stage (using distroless)
FROM gcr.io/distroless/base

# Copy the compiled binary from the build stage
COPY --from=build /app/main .

# Copy the static folder from the build stage
COPY --from=build /app/static /static

# Expose the port the app will run on (port 8080)
EXPOSE 8080

# Run the compiled binary
CMD ["/main"]
