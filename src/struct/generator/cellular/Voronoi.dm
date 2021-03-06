Noise
	Generator
		Cellular
			Voronoi
				get2(x, y)
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_VORONOI2)(num2text(x, 16), num2text(y, 16), num2text(seed, 16), num2text(distance_function, 16), num2text(coeff_1, 16), num2text(coeff_2, 16), num2text(coeff_3, 16), num2text(coeff_4, 16)))

					x += seed
					y += seed

					var
						xi = round(x)
						yi = round(y)
						ycur
						xcur
						xpos
						ypos
						dx
						dy
						dsp
						dist
						list/disp = list(0, 0, 0, 0)
						list/f = list(__MAX_VALUE, __MAX_VALUE, __MAX_VALUE, __MAX_VALUE)
						i
						index

					for(ycur = yi - 3, ycur <= yi + 3, ycur ++)
						for(xcur = xi - 3, xcur <= xi + 3, xcur ++)
							xpos = xcur + simplex.get2(xcur, ycur)
							ypos = ycur + simplex.get2(xcur + 1, ycur + 1,)
							dx = xpos - x
							dy = ypos - y
							dist = call(__distance_function)(dx, dy)
							dsp = simplex.get2(round(xpos), round(ypos), seed + 3)

							if(dist < f[4])
								index = 3

								while(index > 0 && dist < f[index])
									index --

								for(i = 3, i -- > index,)
									f[i + 2] = f[i + 1]
									disp[i + 2] = disp[i + 1]

								f[index + 1] = dist
								disp[index + 1] = dsp

					return disp[1] * coeff_1 + disp[2] * coeff_2 + disp[3] * coeff_3 + disp[4] * coeff_4

				get3(x, y, z)
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_VORONOI3)(num2text(x, 16), num2text(y, 16), num2text(z, 16), num2text(seed, 16), num2text(distance_function, 16), num2text(coeff_1, 16), num2text(coeff_2, 16), num2text(coeff_3, 16), num2text(coeff_4, 16)))

					x += seed
					y += seed
					z += seed

					var
						xi = round(x)
						yi = round(y)
						zi = round(z)
						ycur
						xcur
						zcur
						xpos
						ypos
						zpos
						dx
						dy
						dz
						dist
						dsp
						list/disp = list(0, 0, 0, 0)
						list/f = list(__MAX_VALUE, __MAX_VALUE, __MAX_VALUE, __MAX_VALUE)
						i
						index

					for(zcur = zi - 3, zcur <= zi + 3, zcur ++)
						for(ycur = yi - 3, ycur <= yi + 3, ycur ++)
							for(xcur = xi - 3, xcur <= xi + 3, xcur ++)
								xpos = xcur + simplex.get3(xcur, ycur, zcur)
								ypos = ycur + simplex.get3(xcur + 1, ycur + 1, zcur + 1)
								zpos = zcur + simplex.get3(xcur + 2, ycur + 2, zcur + 2)
								dx = xpos - x
								dy = ypos - y
								dz = zpos - z
								dist = call(__distance_function)(dx, dy, dz)
								dsp = simplex.get3(round(xpos), round(ypos), round(zpos), seed + 3)

								if(dist < f[4])
									index = 3

									while(index > 0 && dist < f[index])
										index --

									for(i = 3, i -- > index,)
										f[i + 2] = f[i + 1]
										disp[i + 2] = disp[i + 1]

									f[index + 1] = dist
									disp[index + 1] = dsp

					return disp[1] * coeff_1 + disp[2] * coeff_2 + disp[3] * coeff_3 + disp[4] * coeff_4