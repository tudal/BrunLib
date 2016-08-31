package pl.brun.lib.util.func {
	/**
	 * @author Marek Brun
	 */
	public function disposeObjectPrimitives(obj:Object):void {
		for(var field:String in obj){
			if(obj[field] is String || obj[field] is Number){
				delete obj[field];
			}else if(obj[field] is Object){
				disposeObjectPrimitives(obj[field])
			}
		}
	}
}
