extends StaticBody2D

func getStartPosition():
	return $groundStartPosition.global_position
	
func getEndPosition():
	return $groundEndPosition.global_position
	
func getMidPosition():
	return $groundMiddlePosition.global_position
