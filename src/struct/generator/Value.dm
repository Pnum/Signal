Noise
	Generator
		Value
			get2(x, y)
				if(SIGNAL_USE_DLL)
					return text2num(call(SIGNAL_DLL_PATH, __DLL_VALUE2)(num2text(x, 16), num2text(y, 16), num2text(seed, 16)))

				var
					x0 = round(x)
					y0 = round(y)

				return __interpXY2(x, y, __QUINTIC_INTERP(x - x0), __QUINTIC_INTERP(y - y0), x0, x0 + 1, y0, y0 + 1, seed, /proc/__valueNoise2)

			get3(x, y, z)
				if(SIGNAL_USE_DLL)
					return text2num(call(SIGNAL_DLL_PATH, __DLL_VALUE3)(num2text(x, 16), num2text(y, 16), num2text(z, 16), num2text(seed, 16)))

				var
					x0 = round(x)
					y0 = round(y)
					z0 = round(z)

				return __interpXYZ3(x, y, z, __QUINTIC_INTERP(x - x0), __QUINTIC_INTERP(y - y0), __QUINTIC_INTERP(z - z0), x0, x0 + 1, y0, y0 + 1, z0, z0 + 1, seed, /proc/__valueNoise3)