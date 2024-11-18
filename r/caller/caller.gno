package caller

import (
	"strconv"

	"gno.land/r/upgradable/callee"
)

var foo = "foo"

var bar = "bar"

type Baz struct {
	Value string
}

var baz = &Baz{Value: "baz"}

var counter = 0

func CallLambdaTakingFunction() string {
	world := "world"

	return callee.LambdaTakingFunction(func(s string) string {
		bar = "baz"

		baz.Value = "qux"

		return s + world + foo
	})
}

func ReadBar() string {
	return bar
}

func ReadBaz() string {
	return baz.Value
}

func StoreAndCallLambda() string {
	callee.StoreLambda(func(s string) string {
		counter++
		return s + strconv.Itoa(counter)
	})

	return callee.CallStoredLambda("hello")
}

var complexCounter uint64 = 0

func CallComplexLambda() uint64 {
	return callee.ComplexLambdaTakingFunction(1, func(i uint64) *uint64 {
		complexCounter += i
		return &complexCounter
	})
}