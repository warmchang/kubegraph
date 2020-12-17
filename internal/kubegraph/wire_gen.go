// Code generated by Wire. DO NOT EDIT.

//go:generate wire
//+build !wireinject

package kubegraph

import (
	"github.com/wwmoraes/dot"
	"github.com/wwmoraes/kubegraph/internal/adapter"
)

import (
	_ "github.com/wwmoraes/kubegraph/internal/adapters"
)

// Injectors from wire.go:

func InitializeKubegraph(optionsFn ...dot.GraphOptionFn) (*KubeGraph, error) {
	graph, err := dot.New(optionsFn...)
	if err != nil {
		return nil, err
	}
	registry := adapter.RegistryInstance()
	kubeGraph := NewKubegraph(graph, registry)
	return kubeGraph, nil
}
