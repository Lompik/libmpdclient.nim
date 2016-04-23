# based of https://raw.githubusercontent.com/cmende/libmpdclient/master/src/example.c
import strfmt
import libmpdclient


proc handle_error(c: ptr  mpd_connection ):void=
  assert(mpd_connection_get_error(c) != MPD_ERROR_SUCCESS)
  echo  mpd_connection_get_error_message(c)
  mpd_connection_free(c)
  quit 1

var conn : ptr mpd_connection

conn = mpd_connection_new(nil, 0, 30000)

if conn.mpd_connection_get_error != MPD_ERROR_SUCCESS:
  handle_error(conn)
discard mpd_command_list_begin(conn, true)
discard mpd_send_status(conn)
discard mpd_send_current_song(conn)
discard mpd_command_list_end(conn)

type CArray*{.unchecked.}[T] = array[0..0, T]
type CPtr*[T] = ptr CArray[T]

var version = mpd_connection_get_server_version(conn)
var versions = cast[CPtr[cuint]](version)

for i in countup(0,2):
  echo "version[" & $i & "]: " & $versions[i]

var status = conn.mpd_recv_status

if(status == nil):
  handle_error(conn)

echo "volume: ", mpd_status_get_volume(status)
echo "repeat: ", mpd_status_get_repeat(status)
echo "queue version: ", mpd_status_get_queue_version(status)
echo "queue length: ", mpd_status_get_queue_length(status)

if mpd_status_get_error(status) != nil:
  echo "error: ", mpd_status_get_error(status)

if mpd_status_get_state(status) == MPD_STATE_PLAY or mpd_status_get_state(status) == MPD_STATE_PAUSE :
  echo "song: ", mpd_status_get_song_pos(status)
  echo "elaspedTime: ",mpd_status_get_elapsed_time(status)
  echo "elasped_ms: ", mpd_status_get_elapsed_ms(status)
  echo "totalTime: ", mpd_status_get_total_time(status)
  echo "bitRate: ", mpd_status_get_kbit_rate(status)

var audio_format =mpd_status_get_audio_format(status);
if (audio_format != nil) :
  echo "sampleRate: ", audio_format[].sample_rate
  echo "bits: ", audio_format[].bits
  echo "channels: ", audio_format[].channels

mpd_status_free(status);

discard mpd_response_next(conn)

proc print_tag( song: ptr mpd_song, tag_type : mpd_tag_type, label:string)=
  var  i:cuint=0
  var value :  cstring
  value = mpd_song_get_tag( song, tag_type, i)
  i+=1
  while value != cast[cstring](nil) :
    echo label & ": " & $value
    value = mpd_song_get_tag( song, tag_type, i)
    i+=1


var song : ptr mpd_song
song = mpd_recv_song(conn)

while (song != nil):
  echo "uri: ", mpd_song_get_uri(song)
  print_tag(song, MPD_TAG_ARTIST, "artist")
  print_tag(song, MPD_TAG_ALBUM, "album")
  print_tag(song, MPD_TAG_TITLE, "title")
  print_tag(song, MPD_TAG_TRACK, "track")
  print_tag(song, MPD_TAG_NAME, "name")
  print_tag(song, MPD_TAG_DATE, "date")

  if (cast[int](mpd_song_get_duration(song)) > 0):
    echo "time: ", mpd_song_get_duration(song)


    echo "pos: ", mpd_song_get_pos(song)

    mpd_song_free(song)
    song = mpd_recv_song(conn)

mpd_connection_free(conn);

## Playlist listing
conn = mpd_connection_new(nil, 0, 30000)

if not mpd_send_list_playlists(conn):
  handle_error(conn)


var playlist:  ptr mpd_playlist = mpd_recv_playlist(conn)
while (playlist != nil) :
  echo "playlist: ", mpd_playlist_get_path(playlist)
  mpd_playlist_free(playlist)
  playlist = mpd_recv_playlist(conn)


mpd_connection_free(conn);
