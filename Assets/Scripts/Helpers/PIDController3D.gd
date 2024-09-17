class_name PIDController3D
var targetPos:Vector3
var targetVel:Vector3
var frequency:float = 1
var damping:float = 1

# <summary>
# Runs an update tick for the PID Controller. Should be called in a FixedUpdate
# </summary>
# <returns>Force that should be applied to rigidbody</returns>
func Update(pFixedDeltaTime:float, pPosition:Vector3, pVelocity:Vector3) -> Vector3:
	var kp:float = (6.0 * frequency) * (6.0 * frequency) * 0.25
	var kd:float = 4.5 * frequency * damping
	var dt:float = pFixedDeltaTime #Time.fixedDeltaTime
	var g:float = 1 / (1 + kd * dt + kp * dt * dt)
	var ksg:float = kp * g
	var kdg:float = (kd + kp * dt) * g
	var Pt0:Vector3 = pPosition
	var Vt0:Vector3 = pVelocity
	var F:Vector3 = (targetPos - Pt0) * ksg + (targetVel - Vt0) * kdg
	return F
