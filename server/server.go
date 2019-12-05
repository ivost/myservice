package server

import (
	"context"
	"log"
	"net"
	"net/http"
	"time"

	"github.com/ivost/shared/pkg/version"

	"github.com/grpc-ecosystem/grpc-gateway/runtime"
	v1 "github.com/ivost/shared/grpc/myservice"
	"github.com/ivost/shared/pkg/config"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/reflection"
)

type Server struct {
	conf *config.Config
	srv  *grpc.Server
	mux  *http.ServeMux
}

func New(conf *config.Config) (s *Server) {
	switch conf.Secure {
	case 0:
		s = &Server{
			conf: conf,
			srv:  grpc.NewServer(),
		}
	case 1:
		// with TLS
		creds, err := credentials.NewServerTLSFromFile(conf.CertFile, conf.KeyFile)
		if err != nil {
			panic(err)
		}
		s = &Server{
			conf: conf,
			srv:  grpc.NewServer(grpc.Creds(creds)),
		}
	case 2:
		// todo
	}
	version.Name = "myserver"
	// Register reflection service on gRPC server.
	reflection.Register(s.srv)
	v1.RegisterMyServiceServer(s.srv, s)
	return s
}

func (s *Server) ListenAndServe() error {
	var err error

	l, err := net.Listen("tcp", s.conf.GrpcAddr)
	if err != nil {
		return err
	}

	log.Printf("%s gRPC Server on %v, secure: %v", version.Name, s.conf.GrpcAddr, s.conf.Secure)

	go func() {
		err = s.srv.Serve(l)
		if err != nil {
			log.Printf("grpc serve error %v", err)
		}
	}()

	// https://grpc-ecosystem.github.io/grpc-gateway/docs/usage.html
	// Note: Make sure the gRPC server is running properly and accessible
	opts := []grpc.DialOption{grpc.WithInsecure()}
	mux := runtime.NewServeMux()

	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	time.Sleep(1 * time.Second)
	err = v1.RegisterMyServiceHandlerFromEndpoint(ctx, mux, s.conf.GrpcAddr, opts)
	if err != nil {
		log.Printf("Register service error %v", err)
		return err
	}
	log.Printf("%s REST Server on %v, secure: %v", version.Name, s.conf.RestAddr, s.conf.Secure)
	return http.ListenAndServe(s.conf.RestAddr, mux)
}
