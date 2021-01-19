package v1

import (
	"fmt"
	"reflect"

	"github.com/wwmoraes/kubegraph/internal/registry"
	rbacV1 "k8s.io/api/rbac/v1"
	"k8s.io/apimachinery/pkg/runtime"
)

type roleAdapter struct {
	registry.Adapter
}

func init() {
	registry.MustRegister(&roleAdapter{
		registry.NewAdapter(
			reflect.TypeOf(&rbacV1.Role{}),
			"icons/role.svg",
		),
	})
}

func (thisAdapter *roleAdapter) tryCastObject(obj runtime.Object) (*rbacV1.Role, error) {
	casted, ok := obj.(*rbacV1.Role)
	if !ok {
		return nil, fmt.Errorf("unable to cast object %s to %s", reflect.TypeOf(obj), thisAdapter.GetType().String())
	}

	return casted, nil
}
