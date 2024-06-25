extends Hazard
class_name Projectile

func AddCollisionException(pRID:RID) -> void:
	($Collider as BulletWithCCD).AddExceptionRID(pRID)
