import "package:node-html-parser.dart" as htmlparser;
import "package:http.dart" as http;
import "package:jsonfile.dart" as jsonfile;

http.get ( process.argv [ 2
]
,
(
res ) { console . log ( res . statusCode , res . statusMessage ) ; res . setEncoding ( "utf8" ) ; final chunks = [ ] ; res . on ( "data" , ( chunk ) { chunks . push ( chunk ) ; } ) ; res . on ( "end" , ( ) { final html = htmlparser . parse ( chunks . join ( ) ) ; final data = { } ; var current_type = "" ; final List < String > props = [ ] ; for ( final node in html . querySelector ( "table" ) . childNodes ) { if ( ! identical ( node . childNodes . length , 0 ) ) { if ( identical ( node . childNodes . length , 2 ) ) { current_type = node . innerText . trim ( ) ; } else { if ( identical ( props . length , 0 ) ) { for ( final inode in node . childNodes ) { if ( ! identical ( inode . rawText , "\n" ) ) { props . push ( inode . innerText . trim ( ) . toLocaleLowerCase ( ) . replace ( new RegExp ( r' ' ) , "_" ) ) ; } } continue ; } ; var i = 0 ; final embed = { } ; for ( final inode in node . childNodes ) { if ( ! identical ( inode . rawText , "\n" ) ) { embed [ props [ i ] ] = inode . innerText . trim ( ) ; i += 1 ; } } if ( ! identical ( current_type , "" ) ) embed [ "type" ] = current_type ; data [ embed [ props [ 0 ] ] . toLocaleLowerCase ( ) . replace ( new RegExp ( r' ' ) , "_" ) ] = embed ; } } } jsonfile . writeFileSync ( process . argv [ 3 ] || "output.json" , data ) ; } ) ; } );