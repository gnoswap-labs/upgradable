package admin 

import (
	"std"
)

var logic Logic = nil

func ReadCounter() uint64 {
	return logic.ReadCounter()
}

func UpdateCounter() {
	logic.UpdateCounter()
}