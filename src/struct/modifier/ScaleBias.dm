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
				return source.get2(x, y) * scale + bias

			get3(x, y, z)
				return source.get3(x, y, z) * scale + bias