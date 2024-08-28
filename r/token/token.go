package token

import (
	"std"

	"gno.land/r/demo/foo"
	"gno.land/r/demo/bar"
)

const entryRealm = "gno.land/r/demo/entry"
var currentLogicRealm = "gno.land/r/demo/logic/v1"

func assertEntryRealm() {
	if std.PrevRealm() != entryRealm {
		panic("Entry realm mismatch")
	}
}

func assertLogicRealm() {
	if std.PrevRealm() != currentLogicRealm {
		panic("Logic realm mismatch")
	}
}

func MigrateLogicRealm(newLogicRealm string) {
	assertEntryRealm()
	currentLogicRealm = newLogicRealm
}

func BalanceOf(token string, address string) uint64 {
	assertLogicRealm()
	switch token {
	case "foo":
		return foo.BalanceOf(address)
	case "bar":
		return bar.BalanceOf(address)
	default:	
		panic("Unknown token")
	}
}

func Transfer(token string, to string, amount uint64) bool {
	assertLogicRealm()
	switch token {
	case "foo":
		return foo.Transfer(to, amount)
	case "bar":
		return bar.Transfer(to, amount)
	default:	
		panic("Unknown token")
	}
}

func Allowance(token string, owner string, spender string) uint64 {
	assertLogicRealm()
	switch token {
	case "foo":
		return foo.Allowance(owner, spender)
	case "bar":
		return bar.Allowance(owner, spender)
	default:	
		panic("Unknown token")
	}
}

func Approve(token string, spender string, amount uint64) bool {
	assertLogicRealm()
	switch token {
	case "foo":
		return foo.Approve(spender, amount)
	case "bar":
		return bar.Approve(spender, amount)
	default:	
		panic("Unknown token")
	}
}

func TransferFrom(token string, from string, to string, amount uint64) bool {
	assertLogicRealm()
	switch token {
	case "foo":
		return foo.TransferFrom(from, to, amount)
	case "bar":
		return bar.TransferFrom(from, to, amount)
	default:	
		panic("Unknown token")
	}
}

