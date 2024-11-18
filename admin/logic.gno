package admin

import (
	"std"
)

type Logic interface {
	ReadCounter() uint64
	UpdateCounter()
}

func RegisterLogic(l Logic, setStore func(Store)) {
	logic = l
	newStore := store()
	setStore(newStore)
}