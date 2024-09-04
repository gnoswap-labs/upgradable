package state

import (
	"fmt"
	"std"
	"strings"
)

const entryRealm = "gno.land/r/demo/entry"
var currentLogicRealm = "gno.land/r/demo/logic/v1"

func assertEntryRealm() {
	if std.PrevRealm().PkgPath() != entryRealm {
		panic(fmt.Sprintf("Entry realm mismatch. Expected: %s, Got: %s", entryRealm, std.PrevRealm().PkgPath()))
	}
}

func assertLogicRealm() {
	prevRealm := std.PrevRealm().PkgPath()
	if prevRealm != currentLogicRealm {
		panic(fmt.Sprintf("Logic realm mismatch. Expected: %s, Got: %s", currentLogicRealm, prevRealm))
	}
}

func MigrateLogicRealm(newLogicRealm string) {
	assertEntryRealm()
	currentLogicRealm = newLogicRealm
	fmt.Printf("Logic realm migrated to: %s\n", newLogicRealm)
}

func GetCurrentLogicRealm() string {
	return currentLogicRealm
}

func GetCurrentLogicVersion() string {
	assertEntryRealm()
	return strings.TrimPrefix(currentLogicRealm, "gno.land/r/demo/logic/")
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
