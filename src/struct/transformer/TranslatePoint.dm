Noise
	Transformer
		TranslatePoint
			source_count_req = 1

			var
				x_translate = 0
				y_translate = 0
				z_translate = 0

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return source.get3(x + x_translate, y + y_translate, z + z_translate)

			get2(x, y)
				x += seed
				y += seed

				return source.get2(x + x_translate, y + y_translate)

			proc
				setTranslate(_x_translate = 0, _y_translate = 0, _z_translate = 0)
					x_translate = _x_translate
					y_translate = _y_translate
					z_translate = _z_translate

				setXTranslate(_x_translate = 0)
					x_translate = _x_translate

				setYTranslate(_y_translate = 0)
					y_translate = _y_translate

				setZTranslate(_z_translate = 0)
					z_translate = _z_translate

				getXTranslate()
					return x_translate

				getYTranslate()
					return y_translate

				getZTranslate()
					return z_translate