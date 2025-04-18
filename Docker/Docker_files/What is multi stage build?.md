# Multi-stage builds
This is a copy from https://docs.docker.com/build/building/multi-stage/
- Multi-stage builds are useful to anyone who has struggled to optimize Dockerfiles while keeping them easy to read and maintain.

# Use multi-stage builds

- With multi-stage builds, you use multiple `FROM` statements in your Dockerfile. 
- Each `FROM` instruction can use a different base, and each of them begins a new stage of the build. 
- You can selectively copy artifacts from one stage to another, leaving behind everything you don't want in the final image.
- The following Dockerfile has two separate stages: one for building a binary,
and another where the binary gets copied from the first stage into the next stage.
```
# syntax=docker/dockerfile:1
FROM golang:1.23
WORKDIR /src
COPY <<EOF ./main.go
package main

import "fmt"

func main() {
  fmt.Println("hello, world")
}
EOF
RUN go build -o /bin/hello ./main.go

FROM scratch
COPY --from=0 /bin/hello /bin/hello
CMD ["/bin/hello"]
```

You only need the single Dockerfile. No need for a separate build script. Just run `docker build`.
```
docker build -t hello .
```
- The end result is a tiny production image with nothing but the binary inside.
- None of the build tools required to build the application are included in the resulting image.
- How does it work?
- The second `FROM` instruction starts a new build stage with the scratch image as its base. 
- The COPY `--from=0` line copies just the built artifact from the previous stage into this new stage. 
- The Go SDK and any intermediate artifacts are left behind, and not saved in the final image.


