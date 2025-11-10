Dim oHfssApp
Dim oDesktop
Dim oProject
Dim oDesign
Dim oEditor
Dim oModule

Set oHfssApp  = CreateObject("AnsoftHfss.HfssScriptInterface")
Set oDesktop = oHfssApp.GetAppDesktop()
oDesktop.RestoreWindow
Set oProject = oDesktop.NewProject
oProject.InsertDesign "HFSS", "HFSSDesign1", "HFSS Terminal Network", ""
oEditor.CreateRectangle _
Array("NAME:RectangleParameters", _
"IsCovered:=", true, _
"XStart:=", "0.000000mm", _
"YStart:=", "0.000000mm", _
"ZStart:=", "0.000000mm", _
"Width:=", "5.000000mm", _
"Height:=", "5.000000mm", _
"WhichAxis:=", "Z"), _
Array("NAME:Attributes", _
"Name:=", "rect", _
"Flags:=", "", _
"Color:=", "(132 132 193)", _
"Transparency:=", 5.000000e-01, _
"PartCoordinateSystem:=", "Global", _
"MaterialName:=", "vacuum", _
"SolveInside:=", true)

Set oModule = oDesign.GetModule("BoundarySetup") 

oModule.AssignAnisotropicImpedance _
Array( _
"NAME:imp1", _
"Objects:=", Array(rect), _
"UseInfiniteGroundPlane:=",fasle,_
"CoordSystem:=","Global",_
"HasExternalLink:=",false,_
"ZxxResistance:=", "5.000000", _
"ZxxReactance:=", "6.000000", _
"ZxyResistance:=", "7.000000", _
"ZxyReactance:=", "8.000000", _
"ZyxResistance:=", "9.000000", _
"ZyxReactance:=", "10.000000", _
"ZyyResistance:=", "11.000000", _
"ZyyReactance:=", "12.000000")