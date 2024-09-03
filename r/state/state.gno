package state

import (
	"std"
)

const entryRealm = "gno.land/r/demo/entry"
var currentLogicRealm = "gno.land/r/demo/logic/v1"

func assertEntryRealm() {
	if std.PrevRealm().PkgPath() != entryRealm {
		panic("Entry realm mismatch")
	}
}

func assertLogicRealm() {
	if std.PrevRealm().PkgPath() != currentLogicRealm {
		panic("Logic realm mismatch")
	}
}

func MigrateLogicRealm(newLogicRealm string) {
	assertEntryRealm()
	currentLogicRealm = newLogicRealm
}

var balanceOf = map[string]uint64{}

func UseBalanceOf() map[string]uint64 {
	assertLogicRealm()
	return balanceOf
}

var totalSupply = uint64(0)

func UseTotalSupply() *uint64 {
	assertLogicRealm()
	return &totalSupply
}

var reserve0 = uint64(0)

func UseReserve0() *uint64 {
	assertLogicRealm()
	return &reserve0
}

var reserve1 = uint64(0)

func UseReserve1() *uint64 {
	assertLogicRealm()
	return &reserve1
}
