package callee

import (
	"std"
)

var lambda func(string) string

func LambdaTakingFunction(f func(string) string) string {
	return f("hello")
}

func StoreLambda(f func(string) string) {
	lambda = f
}

func CallStoredLambda(s string) string {
	return lambda(s)
}

func ComplexLambdaTakingFunction(i uint64, f func(uint64) *uint64) uint64 {
	return *f(i)
}