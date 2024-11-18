package upgradable_testing

import (
	"std"
	"testing"

	"gno.land/p/demo/testutils"
	"gno.land/p/demo/urequire"

	"gno.land/r/upgradable/caller"
)

func TestPackage(t *testing.T) {
	alice := testutils.TestAddress("alice")
	std.TestSetRealm(std.NewUserRealm(alice))
	std.TestSetOrigCaller(alice) // XXX: should not need this

	urequire.Equal(t, caller.CallLambdaTakingFunction(), "helloworldfoo")
	urequire.Equal(t, caller.ReadBar(), "baz")
	urequire.Equal(t, caller.ReadBaz(), "qux")

	urequire.Equal(t, caller.StoreAndCallLambda(), "hello1")
	urequire.Equal(t, caller.StoreAndCallLambda(), "hello2")
	urequire.Equal(t, caller.StoreAndCallLambda(), "hello3")

	urequire.Equal(t, caller.CallComplexLambda(), uint64(1))
	urequire.Equal(t, caller.CallComplexLambda(), uint64(2))
	urequire.Equal(t, caller.CallComplexLambda(), uint64(3))
}