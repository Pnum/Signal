Noise
	Generator
		Cellular
			Worley
				get2(x, y)
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_WORLEY2)(num2text(x, 16), num2text(y, 16), num2text(seed, 16), num2text(distance_function, 16), num2text(coeff_1, 16), num2text(coeff_2, 16), num2text(coeff_3, 16), num2text(coeff_4, 16)))

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
						dist
						f1 = 99999
						f2 = 99999
						f3 = 99999
						f4 = 99999

					for(ycur = yi - 3, ycur <= yi + 3, ycur ++)
						for(xcur = xi - 3, xcur <= xi + 3, xcur ++)
							xpos = xcur + simplex.get2(xcur, ycur)
							ypos = ycur + simplex.get2(xcur + 1, ycur + 1)
							dx = xpos - x
							dy = ypos - y
							dist = call(__distance_function)(dx, dy)

							if(dist < f4)
								if(dist > f3)
									f4 = dist

								else if(dist > f2)
									f4 = f3
									f3 = dist

								else if(dist > f1)
									f4 = f3
									f3 = f2
									f2 = dist

								else
									f4 = f3
									f3 = f2
									f2 = f1
									f1 = dist

					return f1 * coeff_1 + f2 * coeff_2 + f3 * coeff_3 + f4 * coeff_4

				get3(x, y, z)
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_WORLEY3)(num2text(x, 16), num2text(y, 16), num2text(z, 16), num2text(seed, 16), num2text(distance_function, 16), num2text(coeff_1, 16), num2text(coeff_2, 16), num2text(coeff_3, 16), num2text(coeff_4, 16)))

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
						f1 = __MAX_VALUE
						f2 = __MAX_VALUE
						f3 = __MAX_VALUE
						f4 = __MAX_VALUE

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

								if(dist < f4)
									if(dist > f3)
										f4 = dist

									else if(dist > f2)
										f4 = f3
										f3 = dist

									else if(dist > f1)
										f4 = f3
										f3 = f2
										f2 = dist

									else
										f4 = f3
										f3 = f2
										f2 = f1
										f1 = dist

					return f1 * coeff_1 + f2 * coeff_2 + f3 * coeff_3 + f4 * coeff_4