Noise
	Generator
		Simplex
			get2(x, y)
				if(SIGNAL_USE_DLL)
					return text2num(call(SIGNAL_DLL_PATH, __DLL_SIMPLEX2)(num2text(x, 16), num2text(y, 16), num2text(seed, 16)))

				x += seed
				y += seed

				var
					n0
					n1
					n2

					s = (x + y) * 0.36602540378
					i = round(x + s)
					j = round(y + s)

					t = (i + j) * 0.2113248654
					x0 = x - (i - t)
					y0 = y - (j - t)

					i1
					j1

				if(x0 > y0) { i1 = 1; j1 = 0; }
				else { i1 = 0; j1 = 1; }

				var
					x1 = x0 - i1 + 0.2113248654
					y1 = y0 - j1 + 0.2113248654
					x2 = x0 - 1.0 + 2.0 * 0.2113248654
					y2 = y0 - 1.0 + 2.0 * 0.2113248654

					ii = i & 255
					jj = j & 255

					g1 = __simplex_perm_mod12_lut[__simplex_perm_lut[ii + __simplex_perm_lut[jj + 1] + 1] + 1] * 2
					g2 = __simplex_perm_mod12_lut[__simplex_perm_lut[ii + i1 + __simplex_perm_lut[jj + j1 + 1] + 1] + 1] * 2
					g3 = __simplex_perm_mod12_lut[__simplex_perm_lut[ii + 1 + __simplex_perm_lut[jj + 2] + 1] + 1] * 2

					t0 = 0.5 - x0 * x0 - y0 * y0
					t1 = 0.5 - x1 * x1 - y1 * y1
					t2 = 0.5 - x2 * x2 - y2 * y2

				if (t0 < 0) n0 = 0.0
				else
					t0 *= t0
					n0 = t0 * t0 * (__simplex_grad2_lut[g1 + 1] * x0 + __simplex_grad2_lut[g1 + 2] * y0)

				if (t1 < 0) n1 = 0.0
				else
					t1 *= t1
					n1 = t1 * t1 * (__simplex_grad2_lut[g2 + 1] * x1 + __simplex_grad2_lut[g2 + 2] * y1)

				if(t2 < 0) n2 = 0.0
				else
					t2 *= t2
					n2 = t2 * t2 * (__simplex_grad2_lut[g3 + 1] * x2 + __simplex_grad2_lut[g3 + 2] * y2)

				return 70.0 * (n0 + n1 + n2)

			get3(x, y, z)
				if(SIGNAL_USE_DLL)
					return text2num(call(SIGNAL_DLL_PATH, __DLL_SIMPLEX3)(num2text(x, 16), num2text(y, 16), num2text(z, 16), num2text(seed, 16)))

				x += seed
				y += seed
				z += seed

				var
					n0
					n1
					n2
					n3

					s = (x + y + z) * 0.33333333333
					i = round(x + s)
					j = round(y + s)
					k = round(z + s)

					t = (i + j + k) * 0.16666666666
					x0 = x - (i - t)
					y0 = y - (j - t)
					z0 = z - (k - t)

					i1
					j1
					k1
					i2
					j2
					k2

				if(x0 >= y0)
					if (y0 >= z0) { i1 = 1; j1 = 0; k1 = 0; i2 = 1; j2 = 1; k2 = 0; }
					else if (x0 >= z0) { i1 = 1; j1 = 0; k1 = 0; i2 = 1; j2 = 0; k2 = 1; }
					else { i1 = 0; j1 = 0; k1 = 1; i2 = 1; j2 = 0; k2 = 1; }

				else
					if (y0 < z0) { i1 = 0; j1 = 0; k1 = 1; i2 = 0; j2 = 1; k2 = 1; }
					else if (x0 < z0) { i1 = 0; j1 = 1; k1 = 0; i2 = 0; j2 = 1; k2 = 1; }
					else { i1 = 0; j1 = 1; k1 = 0; i2 = 1; j2 = 1; k2 = 0; }

				var
					x1 = x0 - i1 + 0.16666666666
					y1 = y0 - j1 + 0.16666666666
					z1 = z0 - k1 + 0.16666666666
					x2 = x0 - i2 + 2.0 * 0.16666666666
					y2 = y0 - j2 + 2.0 * 0.16666666666
					z2 = z0 - k2 + 2.0 * 0.16666666666
					x3 = x0 - 1.0 + 3.0 * 0.16666666666
					y3 = y0 - 1.0 + 3.0 * 0.16666666666
					z3 = z0 - 1.0 + 3.0 * 0.16666666666

					ii = i & 255
					jj = j & 255
					kk = k & 255

					g1 = __simplex_perm_mod12_lut[__simplex_perm_lut[ii + __simplex_perm_lut[jj + __simplex_perm_lut[kk + 1] + 1] + 1] + 1] * 3
					g2 = __simplex_perm_mod12_lut[__simplex_perm_lut[ii + i1 + __simplex_perm_lut[jj + j1 + __simplex_perm_lut[kk + k1 + 1] + 1] + 1] + 1] * 3
					g3 = __simplex_perm_mod12_lut[__simplex_perm_lut[ii + i2 + __simplex_perm_lut[jj + j2 + __simplex_perm_lut[kk + k2 + 1] + 1] + 1] + 1] * 3
					g4 = __simplex_perm_mod12_lut[__simplex_perm_lut[ii + 1 + __simplex_perm_lut[jj + 1 + __simplex_perm_lut[kk + 2] + 1] + 1] + 1] * 3

					t0 = 0.6 - x0 * x0 - y0 * y0 - z0 * z0
					t1 = 0.6 - x1 * x1 - y1 * y1 - z1 * z1
					t2 = 0.6 - x2 * x2 - y2 * y2 - z2 * z2
					t3 = 0.6 - x3 * x3 - y3 * y3 - z3 * z3

				if(t0 < 0) n0 = 0.0
				else
					t0 *= t0
					n0 = t0 * t0 * (__simplex_grad3_lut[g1 + 1] * x0 + __simplex_grad3_lut[g1 + 2] * y0 + __simplex_grad3_lut[g1 + 3] * z0)

				if(t1 < 0) n1 = 0.0
				else
					t1 *= t1
					n1 = t1 * t1 * (__simplex_grad3_lut[g2 + 1] * x1 + __simplex_grad3_lut[g2 + 2] * y1 + __simplex_grad3_lut[g2 + 3] * z1)

				if(t2 < 0) n2 = 0.0
				else
					t2 *= t2
					n2 = t2 * t2 * (__simplex_grad3_lut[g3 + 1] * x2 + __simplex_grad3_lut[g3 + 2] * y2 + __simplex_grad3_lut[g3 + 3] * z2)

				if(t3 < 0) n3 = 0.0
				else
					t3 *= t3
					n3 = t3 * t3 * (__simplex_grad3_lut[g4 + 1] * x3 + __simplex_grad3_lut[g4 + 2] * y3 + __simplex_grad3_lut[g4 + 3] * z3)

				return 32.0 * (n0 + n1 + n2 + n3)