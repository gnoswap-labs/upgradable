package entry

import (
	"std"
)

var swap func(prev string, tokenIn string, amountIn uint64) (amountOut uint64)

func Swap(tokenIn string, amountIn uint64) (amountOut uint64) {
	return swap(std.PrevRealm().PkgPath(), tokenIn, amountIn)
}

var addLiquidity func(prev string, amount0 uint64, amount1 uint64) (shareAmount uint64)

func AddLiquidity(amount0 uint64, amount1 uint64) (shareAmount uint64) {
	return addLiquidity(std.PrevRealm().PkgPath(), amount0, amount1)
}

var removeLiquidity func(prev string, shareAmount uint64) (amount0 uint64, amount1 uint64)

func RemoveLiquidity(shareAmount uint64) (amount0 uint64, amount1 uint64) {
	return removeLiquidity(std.PrevRealm().PkgPath(), shareAmount)
}
