package token

import (
	"std"

	"gno.land/r/onbloc/foo"
	"gno.land/r/onbloc/bar"
	"gno.land/p/demo/users"
)

const entryRealmPath = "gno.land/r/demo/entry"
var currentLogicRealmPath = "gno.land/r/demo/logic/v1"

func assertEntryRealm() {
	if std.PrevRealm().PkgPath() != entryRealmPath {
		panic("Entry realm mismatch")
	}
}

func assertLogicRealm() {
	if std.PrevRealm().PkgPath() != currentLogicRealmPath {
		panic("Logic realm mismatch")
	}
}

func MigrateLogicRealm(newLogicRealmPath string) {
	assertEntryRealm()
	currentLogicRealmPath = newLogicRealmPath
}

func BalanceOf(token string, address string) uint64 {
	assertLogicRealm()

	addr := users.AddressOrName(address)
	switch token {
	case "foo":
		return foo.BalanceOf(addr)
	case "bar":
		return bar.BalanceOf(addr)
	default:	
		panic("Unknown token")
	}
}

func Transfer(token string, to string, amount uint64) {
	assertLogicRealm()

	toAddr := users.AddressOrName(to)
	switch token {
	case "foo":
		foo.Transfer(toAddr, amount)
	case "bar":
		bar.Transfer(toAddr, amount)
	default:	
		panic("Unknown token")
	}
}

func Allowance(token string, owner string, spender string) uint64 {
	assertLogicRealm()

	ownerAddr := users.AddressOrName(owner)
	spenderAddr := users.AddressOrName(spender)

	switch token {
	case "foo":
		return foo.Allowance(ownerAddr, spenderAddr)
	case "bar":
		return bar.Allowance(ownerAddr, spenderAddr)
	default:	
		panic("Unknown token")
	}
}

func Approve(token string, spender string, amount uint64) {
	assertLogicRealm()

	spenderAddr := users.AddressOrName(spender)
	switch token {
	case "foo":
		foo.Approve(spenderAddr, amount)
	case "bar":
		bar.Approve(spenderAddr, amount)
	default:	
		panic("Unknown token")
	}
}

func TransferFrom(token string, from string, to string, amount uint64) bool {
	assertLogicRealm()

	fromAddr := users.AddressOrName(from)
	toAddr := users.AddressOrName(to)
	switch token {
	case "foo":
		foo.TransferFrom(fromAddr, toAddr, amount)
	case "bar":
		bar.TransferFrom(fromAddr, toAddr, amount)
	default:	
		panic("Unknown token")
	}
}
