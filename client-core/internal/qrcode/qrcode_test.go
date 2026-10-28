package qrcode

import "testing"

func TestEncode(t *testing.T) {
	size, modules, err := Encode("http://192.168.1.5:8790/#i=bHszbX1E9Uv65fxQlkRzqQ&k=0E8KNpiF3xcgeVD2d4rC0PN33nj35KUWV_lI78OrQ80")
	if err != nil {
		t.Fatal(err)
	}
	if size < 21 || len(modules) != size*size {
		t.Fatalf("size %d, %d 个模块", size, len(modules))
	}
	// 三个角上的定位图案：左上角 7×7 的外框是深色
	for i := 0; i < 7; i++ {
		if modules[i] != 1 || modules[i*size] != 1 {
			t.Fatalf("左上角的定位图案不对")
		}
	}
}
