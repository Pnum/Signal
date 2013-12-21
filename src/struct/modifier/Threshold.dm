Noise
	Modifier
		Threshold
			source_count_req = 1

			var
				threshold = 0
				new_low = -1
				new_high = 1

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				var/val = source.get3(x, y, z)

				if(val < threshold) val = new_low
				if(val >= threshold) val = new_high

				return val

			get2(x, y)
				x += seed
				y += seed

				var/val = source.get2(x, y)

				if(val < threshold) val = new_low
				if(val >= threshold) val = new_high

				return val

			proc
				setThreshold(_threshold)
					threshold = _threshold

				setNewLow(_new_low)
					new_low = _new_low

				setNewHigh(_new_high)
					new_high = _new_high

				getThreshold()
					return threshold

				getNewLow()
					return new_low

				getNewHigh()
					return new_high