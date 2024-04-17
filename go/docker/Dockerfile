FROM golang:1.20.2-alpine3.16 as build
WORKDIR /app
COPY . .
RUN go build -o main main.go

FROM public.ecr.aws/lambda/provided:al2023
COPY --from=build /app/main /main
ENTRYPOINT [ "/main" ]
