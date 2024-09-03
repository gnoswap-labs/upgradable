package logic

import (
	"std"

	state "gno.land/r/demo/state"
	token "gno.land/r/demo/token"
)

const token0 = "foo"
const token1 = "bar"
var balanceOf = state.UseBalanceOf()
var totalSupply = state.UseTotalSupply()
var reserve0 = state.UseReserve0()
var reserve1 = state.UseReserve1()

func mint(address string, amount uint64) {
	balanceOf[address] += amount
	*totalSupply += amount
}

func burn(address string, amount uint64) {
	balanceOf[address] -= amount
	*totalSupply -= amount
}

func update(_reserve0 uint64, _reserve1 uint64) {
	*reserve0 = _reserve0
	*reserve1 = _reserve1
}

const entryRealm = "gno.land/r/demo/entry"

func assertEntryRealm() {
	if std.PrevRealm() != entryRealm {
		panic("Entry realm mismatch")
	}
}

func Swap(prev string, tokenIn string, amountIn uint64) (amountOut uint64) {
	assertEntryRealm()
	return 0 // unimplemented
}

func AddLiquidity(prev string, amount0 uint64, amount1 uint64) (shareAmount uint64) {
	assertEntryRealm()
	
	token.TransferFrom(token0, prev, std.CurrentRealm(), amount0)
	token.TransferFrom(token1, prev, std.CurrentRealm(), amount1)

	if *totalSupply == 0 {
		shareAmount = sqrt(amount0 * amount1)
	} else {
		shareAmount = min(amount0 * *totalSupply / *reserve0, amount1 * *totalSupply / *reserve1)
	}

	mint(prev, shareAmount)

	update(token.BalanceOf(token0, std.CurrentRealm()), token.BalanceOf(token1, std.CurrentRealm()))

	return shareAmount
}

func RemoveLiquidity(prev string, shareAmount uint64) (amount0 uint64, amount1 uint64) {
	assertEntryRealm()
	return 0, 0 // unimplemented
}

func sqrt(y uint64) (z uint64) {
	if y > 3 {
		z = y
		x := y / 2 + 1
		for x < z {
			z = x
			x = (y / x + x) / 2
		}
	} else if y != 0 {
		z = 1
	}
}

func min(x uint64, y uint64) uint64 {
	if x < y {
		return x
	}
	return y
}
