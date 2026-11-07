# 截图用的背景图：像素风的落日山景，240×150 画好再按 8 倍放大（无插值），写成 PPM。
# 是程序画的原创图，可以放进官网截图。用法：
#   python3 pixelscape.py scape.ppm 8 && ffmpeg -i scape.ppm scape.png
# 再用后台服务的 ImportBackground 导入（重新编码、算模糊版与分析结果），得到这个目录里的
# sharp.img、blur.img 与 info.json。
import math, random, sys
W, H = 240, 150
random.seed(7)
sky = [(43,27,74),(74,40,104),(122,52,120),(178,71,122),(222,104,104),(245,158,91),(255,206,140)]
bayer = [[0,8,2,10],[12,4,14,6],[3,11,1,9],[15,7,13,5]]
img = [[(0,0,0)]*W for _ in range(H)]
for y in range(H):
    t = y / (H*0.78) * (len(sky)-1)
    for x in range(W):
        i = min(int(t + (bayer[y%4][x%4]/16 - 0.5)), len(sky)-1)
        img[y][x] = sky[max(i,0)]
# 太阳
cx, cy, r = 168, 92, 20
for y in range(H):
    for x in range(W):
        if (x-cx)**2 + (y-cy)**2 <= r*r and (y < cy-6 or (y-cy) % 4 != 0):
            img[y][x] = (255, 228, 160)
# 星星
for _ in range(40):
    x, y = random.randrange(W), random.randrange(40)
    img[y][x] = (255, 236, 200)
def ridge(base, amp, freq, seed, color, dither=None):
    random.seed(seed)
    ph = [random.random()*6 for _ in range(3)]
    for x in range(W):
        h = base - amp*(0.6*math.sin(x*freq+ph[0]) + 0.3*math.sin(x*freq*2.3+ph[1]) + 0.15*math.sin(x*freq*5.1+ph[2]))
        h = int(round(h/2)*2)
        for y in range(max(h,0), H):
            c = color
            if dither and y < h+3 and (x+y) % 2 == 0:
                c = dither
            img[y][x] = c
ridge(100, 22, 0.035, 1, (96,48,108), (140,64,120))
ridge(116, 16, 0.05, 2, (62,34,84), (96,48,108))
ridge(132, 10, 0.08, 3, (34,22,56), (62,34,84))
# 松树
random.seed(11)
for _ in range(26):
    x0 = random.randrange(W); top = random.randrange(128, 140); hgt = random.randrange(8, 14)
    for k in range(hgt):
        w = k//2
        for dx in range(-w, w+1):
            if 0 <= x0+dx < W and top+k < H: img[top+k][x0+dx] = (22,16,38)
S = int(sys.argv[2]) if len(sys.argv) > 2 else 8
with open(sys.argv[1], 'wb') as f:
    f.write(b'P6 %d %d 255\n' % (W*S, H*S))
    for y in range(H):
        row = bytearray()
        for x in range(W):
            row += bytes(img[y][x]) * S
        f.write(bytes(row) * S)
