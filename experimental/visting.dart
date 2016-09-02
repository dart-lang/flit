/* A sketch of the code needed to allow Observatory to access
 * the Flutter element/widget/render tree(s).
 * This stuff ultimately needs to go into
 *  the files rendering/bindings.dart and widgets/bindings.dart.
 *  What's missing now is an encoding of the actual Flutter objects
 *  collected  here into a JSONable form. These need to serialized into maps
 *  to whatever depth we find useful.  Observatory has expectations wrt to
 *  this - it expects a type field for example.
 *
 *  It may be possible to use the VM's facilities to provide "stable-ish"
 *  object ids that can be serialized, which could then be used to
 *  manipulate the objects or retrieve more information. This would
 *  require additional VM support.
 */

import 'dart:async' show Future;

import 'package:widgets/framework.dart' as flutter show Element, RenderElement;
import 'package:widgets/bindings.dart' as flutterWidgetBindings
    show WidgetBinding;

List<Map<String, dynamic>> stack;

flutter.Element tree =
    flutterWidgetBindings.WidgetBinding.instance.renderViewElement;
// the root of the element tree

push(Map<String, dynamic> e) {
  stack.add(e);
}

Map<String, dynamic> get pop {
  return stack.removeLast();
}

Map<String, dynamic> get top {
  return stack.last;
}

Map<String, dynamic> mapWidget(e) {
  return {'type': mapType(e.runtimeType)};
}

Map<String, dynamic> mapRenderObject(e) {
  return {'type': mapType(e.runtimeType)};
}

Map<String, dynamic> mapElement(e) {
  return {
    'type': mapType(e.runtimeType),
    'widget': mapWidget(e.widget),
    'isRenderElement': e is flutter.RenderElement,
    'renderObject': mapRenderObject(e.renderObject)
  };
}

Map<String, dynamic> elementMap(flutter.Element e) {
  return {'element': mapElement(e), 'children': []};
}

Map<String, dynamic> widgetMap(flutter.Element e) {
  return {'widget': mapElement(e), 'children': []};
}

Map<String, dynamic> renderObjectMap(flutter.Element e) {
  return {'renderObject': mapElement(e), 'children': []};
}

String mapType(Type t) => t.toString();

void elementCollector(flutter.Element e) {
  var map = elementMap(e);
  top['children]'].add(map);
  push(map);
  e.visitChildren(elementCollector);
  pop;
}

void widgetCollector(flutter.Element e) {
  var map = widgetMap(e);
  top['children]'].add(map);
  push(map);
  e.visitChildren(widgetCollector);
  pop;
}

void renderObjectCollector(flutter.Element e) {
  var map = renderObjectMap(e);
  top['children]'].add(map);
  push(map);
  e.visitChildren(renderObjectCollector);
  pop;
}

Future<Map<String, dynamic>> debugReturnElementTree() async {
  stack = [
    {'children': []}
  ];
  tree.visitChildren(elementCollector);
  return top;
}

Future<Map<String, dynamic>> debugReturnWidgetTree() async {
  stack = [
    {'children': []}
  ];
  tree.visitChildren(widgetCollector);
  return top;
}

Future<Map<String, dynamic>> debugReturnRenderObjectTree() async {
  stack = [
    {'children': []}
  ];
  tree.visitChildren(renderObjectCollector);
  return top;
}

main() {
  registerServiceExtension('returnElementTree', debugReturnElementTree);
  registerServiceExtension('returnWidgetTree', debugReturnWidgetTree);
  // to be added to WidgetBinding.initServiceExtensions

  registerServiceExtension(
      'returnRenderObjectTree', debugReturnRenderObjectTree);
  // to be added to RenderBinding.initServiceExtensions
}
