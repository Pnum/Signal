Noise
	Modifier
		ScaleBias
			source_count_req = 1

			var
				bias = 0
				scale = 1

			proc
				setBias(_bias)
					bias = _bias

				setScale(_scale)
					scale = _scale

				getBias()
					return bias

				getScale()
					return scale

			get2(x, y)
				x += seed
				y += seed

				return source.get2(x, y) * scale + bias

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return source.get3(x, y, z) * scale + bias