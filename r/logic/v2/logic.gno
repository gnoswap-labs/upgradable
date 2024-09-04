package v2

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
	if std.PrevRealm().PkgPath() != entryRealm {
		panic("Entry realm mismatch")
	}
}

func Swap(prev string, tokenIn string, amountIn uint64) (amountOut uint64) {
	assertEntryRealm()
	
	var reserveIn, reserveOut *uint64
	var tokenOut string
	if tokenIn == token0 {
		reserveIn, reserveOut = reserve0, reserve1
		tokenOut = token1
	} else if tokenIn == token1 {
		reserveIn, reserveOut = reserve1, reserve0
		tokenOut = token0
	} else {
		panic("Invalid token")
	}
	
	// Apply a 0.3% fee
	amountInWithFee := amountIn * 997
	numerator := amountInWithFee * *reserveOut
	denominator := *reserveIn * 1000 + amountInWithFee
	amountOut = numerator / denominator
	
	if amountOut == 0 {
		panic("Insufficient output amount")
	}
	
	token.TransferFrom(tokenIn, prev, std.CurrentRealm(), amountIn)
	token.Transfer(tokenOut, prev, amountOut)
	
	var newReserve0, newReserve1 uint64
	if tokenIn == token0 {
		newReserve0 = *reserve0 + amountIn
		newReserve1 = *reserve1 - amountOut
	} else {
		newReserve0 = *reserve0 - amountOut
		newReserve1 = *reserve1 + amountIn
	}
	update(newReserve0, newReserve1)
	
	return amountOut
}

func AddLiquidity(prev string, amount0 uint64, amount1 uint64) (shareAmount uint64) {
	assertEntryRealm()
	
	token.TransferFrom(token0, prev, std.CurrentRealm(), amount0)
	token.TransferFrom(token1, prev, std.CurrentRealm(), amount1)

	if *totalSupply == 0 {
		shareAmount = sqrt(amount0 * amount1)
	} else {
		shareAmount0 := amount0 * *totalSupply / *reserve0
		shareAmount1 := amount1 * *totalSupply / *reserve1
		if shareAmount0 < shareAmount1 {
			shareAmount = shareAmount0
		} else {
			shareAmount = shareAmount1
		}
	}

	mint(prev, shareAmount)

	update(token.BalanceOf(token0, std.CurrentRealm()), token.BalanceOf(token1, std.CurrentRealm()))

	return shareAmount
}

func RemoveLiquidity(prev string, shareAmount uint64) (amount0 uint64, amount1 uint64) {
	assertEntryRealm()
	
	amount0 = shareAmount * *reserve0 / *totalSupply
	amount1 = shareAmount * *reserve1 / *totalSupply
	
	burn(prev, shareAmount)
	
	token.Transfer(token0, prev, amount0)
	token.Transfer(token1, prev, amount1)
	
	update(*reserve0 - amount0, *reserve1 - amount1)
	
	return amount0, amount1
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
	return z
}

// Getter functions
func GetReserves() (uint64, uint64) {
	return *reserve0, *reserve1
}

func GetTotalSupply() uint64 {
	return *totalSupply
}

func GetBalanceOf(address string) uint64 {
	return balanceOf[address]
}
