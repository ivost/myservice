package server

import (
	"context"
	"time"

	"github.com/golang/protobuf/ptypes/empty"
	v1 "github.com/ivost/shared/grpc/myservice"
	"github.com/ivost/shared/pkg/system"
	"github.com/ivost/shared/pkg/version"
)

func (s *Server) Health(ctx context.Context, none *empty.Empty) (resp *v1.HealthResponse, err error) {
	resp = &v1.HealthResponse{
		Name:    "myservice",
		Version: version.Version,
		Build:   version.Build,
		Status:  "OK",
		Time:    time.Now().Format(time.RFC3339),
		Address: system.MyIP(),
	}
	return
}
