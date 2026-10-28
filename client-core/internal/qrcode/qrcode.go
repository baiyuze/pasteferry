// Package qrcode 把文字编成二维码点阵，交给界面自己画：手机网页传输与扫码配对的二维码都用它。
// 界面按点阵画方块，颜色跟随主题，任何尺寸都清晰，不用在 Flutter 里另加二维码依赖。
package qrcode

import "rsc.io/qr"

// Encode 返回二维码的边长（模块数）与按行排列的模块，每个字节一个模块，1 为深色。
// 纠错等级用 M：屏幕上显示，不会被弄脏，M 已经足够，码也不会太密。
func Encode(text string) (size int, modules []byte, err error) {
	code, err := qr.Encode(text, qr.M)
	if err != nil {
		return 0, nil, err
	}
	size = code.Size
	modules = make([]byte, size*size)
	for y := 0; y < size; y++ {
		for x := 0; x < size; x++ {
			if code.Black(x, y) {
				modules[y*size+x] = 1
			}
		}
	}
	return size, modules, nil
}
