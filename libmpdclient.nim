 {.deadCodeElim: on.}

import Times

when defined(windows):
  const
    mpdll* = "mpdclient.dll"
elif defined(macosx):
  const
    mpdll* = "libmpdclient.dylib"
else:
  const
    mpdll* = "libmpdclient.so"
const
  MPD_SAMPLE_FORMAT_FLOAT* = 0x000000E0
  MPD_SAMPLE_FORMAT_DSD* = 0x000000E1

type
  mpd_song* = object

  mpd_connection* = object

  mpd_playlist* = object

  mpd_settings* = object

  mpd_stats* = object

  mpd_entity* = object

  mpd_status* = object

  mpd_audio_format* = object
    sample_rate*: uint32
    bits*: uint8
    channels*: uint8
    reserved0*: uint16
    reserved1*: uint32

  mpd_state* {.size: sizeof(cint).} = enum
    MPD_STATE_UNKNOWN = 0, MPD_STATE_STOP = 1, MPD_STATE_PLAY = 2, MPD_STATE_PAUSE = 3


type
  mpd_operator* {.size: sizeof(cint).} = enum
    MPD_OPERATOR_DEFAULT


type
  mpd_entity_type* {.size: sizeof(cint).} = enum
    MPD_ENTITY_TYPE_UNKNOWN, MPD_ENTITY_TYPE_DIRECTORY, MPD_ENTITY_TYPE_SONG,
    MPD_ENTITY_TYPE_PLAYLIST


type
  mpd_server_error* {.size: sizeof(cint).} = enum
    MPD_SERVER_ERROR_UNK = - 1, MPD_SERVER_ERROR_NOT_LIST = 1,
    MPD_SERVER_ERROR_ARG = 2, MPD_SERVER_ERROR_PASSWORD = 3,
    MPD_SERVER_ERROR_PERMISSION = 4, MPD_SERVER_ERROR_UNKNOWN_CMD = 5,
    MPD_SERVER_ERROR_NO_EXIST = 50, MPD_SERVER_ERROR_PLAYLIST_MAX = 51,
    MPD_SERVER_ERROR_SYSTEM = 52, MPD_SERVER_ERROR_PLAYLIST_LOAD = 53,
    MPD_SERVER_ERROR_UPDATE_ALREADY = 54, MPD_SERVER_ERROR_PLAYER_SYNC = 55,
    MPD_SERVER_ERROR_EXIST = 56


type
  mpd_error* {.size: sizeof(cint).} = enum
    MPD_ERROR_SUCCESS = 0, MPD_ERROR_OOM, MPD_ERROR_ARGUMENT, MPD_ERROR_STATE,
    MPD_ERROR_TIMEOUT, MPD_ERROR_SYSTEM, MPD_ERROR_RESOLVER, MPD_ERROR_MALFORMED,
    MPD_ERROR_CLOSED, MPD_ERROR_SERVER


type
  mpd_tag_type* {.size: sizeof(cint).} = enum
    MPD_TAG_UNKNOWN = - 1, MPD_TAG_ARTIST, MPD_TAG_ALBUM, MPD_TAG_ALBUM_ARTIST,
    MPD_TAG_TITLE, MPD_TAG_TRACK, MPD_TAG_NAME, MPD_TAG_GENRE, MPD_TAG_DATE,
    MPD_TAG_COMPOSER, MPD_TAG_PERFORMER, MPD_TAG_COMMENT, MPD_TAG_DISC,
    MPD_TAG_MUSICBRAINZ_ARTISTID, MPD_TAG_MUSICBRAINZ_ALBUMID,
    MPD_TAG_MUSICBRAINZ_ALBUMARTISTID, MPD_TAG_MUSICBRAINZ_TRACKID,
    MPD_TAG_MUSICBRAINZ_RELEASETRACKID, MPD_TAG_COUNT


type
  mpd_idle* {.size: sizeof(cint).} = enum
    MPD_IDLE_DATABASE = 0x00000001, MPD_IDLE_STORED_PLAYLIST = 0x00000002,
    MPD_IDLE_QUEUE = 0x00000004, MPD_IDLE_PLAYER = 0x00000008,
    MPD_IDLE_MIXER = 0x00000010, MPD_IDLE_OUTPUT = 0x00000020,
    MPD_IDLE_OPTIONS = 0x00000040, MPD_IDLE_UPDATE = 0x00000080,
    MPD_IDLE_STICKER = 0x00000100, MPD_IDLE_SUBSCRIPTION = 0x00000200,
    MPD_IDLE_MESSAGE = 0x00000400

const
  MPD_IDLE_PLAYLIST = MPD_IDLE_QUEUE

type
  mpd_pair* = object
    name*: cstring
    value*: cstring


proc mpd_recv_pair*(connection: ptr mpd_connection): ptr mpd_pair {.cdecl,
    importc: "mpd_recv_pair", dynlib: mpdll.}
proc mpd_recv_pair_named*(connection: ptr mpd_connection; name: cstring): ptr mpd_pair {.
    cdecl, importc: "mpd_recv_pair_named", dynlib: mpdll.}
proc mpd_return_pair*(connection: ptr mpd_connection; pair: ptr mpd_pair) {.cdecl,
    importc: "mpd_return_pair", dynlib: mpdll.}
proc mpd_enqueue_pair*(connection: ptr mpd_connection; pair: ptr mpd_pair) {.cdecl,
    importc: "mpd_enqueue_pair", dynlib: mpdll.}
proc mpd_send_allowed_commands*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_allowed_commands", dynlib: mpdll.}
proc mpd_send_disallowed_commands*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_disallowed_commands", dynlib: mpdll.}
proc mpd_recv_command_pair*(connection: ptr mpd_connection): ptr mpd_pair {.inline,
    cdecl.} =
  return mpd_recv_pair_named(connection, "command")

proc mpd_send_list_url_schemes*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_list_url_schemes", dynlib: mpdll.}
proc mpd_recv_url_scheme_pair*(connection: ptr mpd_connection): ptr mpd_pair {.inline,
    cdecl.} =
  return mpd_recv_pair_named(connection, "handler")

proc mpd_send_list_tag_types*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_list_tag_types", dynlib: mpdll.}
proc mpd_recv_tag_type_pair*(connection: ptr mpd_connection): ptr mpd_pair {.inline,
    cdecl.} =
  return mpd_recv_pair_named(connection, "tagtype")

type
  mpd_async* = object


proc mpd_connection_new*(host: cstring; port: cuint; timeout_ms: cuint): ptr mpd_connection {.
    cdecl, importc: "mpd_connection_new", dynlib: mpdll.}
proc mpd_connection_new_async*(async: ptr mpd_async; welcome: cstring): ptr mpd_connection {.
    cdecl, importc: "mpd_connection_new_async", dynlib: mpdll.}
proc mpd_connection_free*(connection: ptr mpd_connection) {.cdecl,
    importc: "mpd_connection_free", dynlib: mpdll.}
proc mpd_connection_get_settings*(connection: ptr mpd_connection): ptr mpd_settings {.
    cdecl, importc: "mpd_connection_get_settings", dynlib: mpdll.}
proc mpd_connection_set_keepalive*(connection: ptr mpd_connection; keepalive: bool) {.
    cdecl, importc: "mpd_connection_set_keepalive", dynlib: mpdll.}
proc mpd_connection_set_timeout*(connection: ptr mpd_connection; timeout_ms: cuint) {.
    cdecl, importc: "mpd_connection_set_timeout", dynlib: mpdll.}
proc mpd_connection_get_fd*(connection: ptr mpd_connection): cint {.cdecl,
    importc: "mpd_connection_get_fd", dynlib: mpdll.}
proc mpd_connection_get_async*(connection: ptr mpd_connection): ptr mpd_async {.cdecl,
    importc: "mpd_connection_get_async", dynlib: mpdll.}
proc mpd_connection_get_error*(connection: ptr mpd_connection): mpd_error {.cdecl,
    importc: "mpd_connection_get_error", dynlib: mpdll.}
proc mpd_connection_get_error_message*(connection: ptr mpd_connection): cstring {.
    cdecl, importc: "mpd_connection_get_error_message", dynlib: mpdll.}
proc mpd_connection_get_server_error*(connection: ptr mpd_connection): mpd_server_error {.
    cdecl, importc: "mpd_connection_get_server_error", dynlib: mpdll.}
proc mpd_connection_get_server_error_location*(connection: ptr mpd_connection): cuint {.
    cdecl, importc: "mpd_connection_get_server_error_location", dynlib: mpdll.}
proc mpd_connection_get_system_error*(connection: ptr mpd_connection): cint {.cdecl,
    importc: "mpd_connection_get_system_error", dynlib: mpdll.}
proc mpd_connection_clear_error*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_connection_clear_error", dynlib: mpdll.}
proc mpd_connection_get_server_version*(connection: ptr mpd_connection): ptr cuint {.
    cdecl, importc: "mpd_connection_get_server_version", dynlib: mpdll.}
proc mpd_connection_cmp_server_version*(connection: ptr mpd_connection;
                                       major: cuint; minor: cuint; patch: cuint): cint {.
    cdecl, importc: "mpd_connection_cmp_server_version", dynlib: mpdll.}
proc mpd_send_list_all*(connection: ptr mpd_connection; path: cstring): bool {.cdecl,
    importc: "mpd_send_list_all", dynlib: mpdll.}
proc mpd_send_list_all_meta*(connection: ptr mpd_connection; path: cstring): bool {.
    cdecl, importc: "mpd_send_list_all_meta", dynlib: mpdll.}
proc mpd_send_list_meta*(connection: ptr mpd_connection; path: cstring): bool {.cdecl,
    importc: "mpd_send_list_meta", dynlib: mpdll.}
proc mpd_send_read_comments*(connection: ptr mpd_connection; path: cstring): bool {.
    cdecl, importc: "mpd_send_read_comments", dynlib: mpdll.}
proc mpd_send_update*(connection: ptr mpd_connection; path: cstring): bool {.cdecl,
    importc: "mpd_send_update", dynlib: mpdll.}
proc mpd_send_rescan*(connection: ptr mpd_connection; path: cstring): bool {.cdecl,
    importc: "mpd_send_rescan", dynlib: mpdll.}
proc mpd_recv_update_id*(connection: ptr mpd_connection): cuint {.cdecl,
    importc: "mpd_recv_update_id", dynlib: mpdll.}
proc mpd_run_update*(connection: ptr mpd_connection; path: cstring): cuint {.cdecl,
    importc: "mpd_run_update", dynlib: mpdll.}
proc mpd_run_rescan*(connection: ptr mpd_connection; path: cstring): cuint {.cdecl,
    importc: "mpd_run_rescan", dynlib: mpdll.}
type
  mpd_directory* = object


proc mpd_directory_dup*(directory: ptr mpd_directory): ptr mpd_directory {.cdecl,
    importc: "mpd_directory_dup", dynlib: mpdll.}
proc mpd_directory_free*(directory: ptr mpd_directory) {.cdecl,
    importc: "mpd_directory_free", dynlib: mpdll.}
proc mpd_directory_get_path*(directory: ptr mpd_directory): cstring {.cdecl,
    importc: "mpd_directory_get_path", dynlib: mpdll.}
proc mpd_directory_get_last_modified*(directory: ptr mpd_directory): Time {.cdecl,
    importc: "mpd_directory_get_last_modified", dynlib: mpdll.}
proc mpd_directory_begin*(pair: ptr mpd_pair): ptr mpd_directory {.cdecl,
    importc: "mpd_directory_begin", dynlib: mpdll.}
proc mpd_directory_feed*(directory: ptr mpd_directory; pair: ptr mpd_pair): bool {.
    cdecl, importc: "mpd_directory_feed", dynlib: mpdll.}
proc mpd_recv_directory*(connection: ptr mpd_connection): ptr mpd_directory {.cdecl,
    importc: "mpd_recv_directory", dynlib: mpdll.}
proc mpd_tag_name*(`type`: mpd_tag_type): cstring {.cdecl, importc: "mpd_tag_name",
    dynlib: mpdll.}
proc mpd_tag_name_parse*(name: cstring): mpd_tag_type {.cdecl,
    importc: "mpd_tag_name_parse", dynlib: mpdll.}
proc mpd_tag_name_iparse*(name: cstring): mpd_tag_type {.cdecl,
    importc: "mpd_tag_name_iparse", dynlib: mpdll.}
proc mpd_song_free*(song: ptr mpd_song) {.cdecl, importc: "mpd_song_free",
                                      dynlib: mpdll.}
proc mpd_song_dup*(song: ptr mpd_song): ptr mpd_song {.cdecl, importc: "mpd_song_dup",
    dynlib: mpdll.}
proc mpd_song_get_uri*(song: ptr mpd_song): cstring {.cdecl,
    importc: "mpd_song_get_uri", dynlib: mpdll.}
proc mpd_song_get_tag*(song: ptr mpd_song; `type`: mpd_tag_type; idx: cuint): cstring {.
    cdecl, importc: "mpd_song_get_tag", dynlib: mpdll.}
proc mpd_song_get_duration*(song: ptr mpd_song): cuint {.cdecl,
    importc: "mpd_song_get_duration", dynlib: mpdll.}
proc mpd_song_get_duration_ms*(song: ptr mpd_song): cuint {.cdecl,
    importc: "mpd_song_get_duration_ms", dynlib: mpdll.}
proc mpd_song_get_start*(song: ptr mpd_song): cuint {.cdecl,
    importc: "mpd_song_get_start", dynlib: mpdll.}
proc mpd_song_get_end*(song: ptr mpd_song): cuint {.cdecl,
    importc: "mpd_song_get_end", dynlib: mpdll.}
proc mpd_song_get_last_modified*(song: ptr mpd_song): Time {.cdecl,
    importc: "mpd_song_get_last_modified", dynlib: mpdll.}
proc mpd_song_set_pos*(song: ptr mpd_song; pos: cuint) {.cdecl,
    importc: "mpd_song_set_pos", dynlib: mpdll.}
proc mpd_song_get_pos*(song: ptr mpd_song): cuint {.cdecl,
    importc: "mpd_song_get_pos", dynlib: mpdll.}
proc mpd_song_get_id*(song: ptr mpd_song): cuint {.cdecl, importc: "mpd_song_get_id",
    dynlib: mpdll.}
proc mpd_song_get_prio*(song: ptr mpd_song): cuint {.cdecl,
    importc: "mpd_song_get_prio", dynlib: mpdll.}
proc mpd_song_begin*(pair: ptr mpd_pair): ptr mpd_song {.cdecl,
    importc: "mpd_song_begin", dynlib: mpdll.}
proc mpd_song_feed*(song: ptr mpd_song; pair: ptr mpd_pair): bool {.cdecl,
    importc: "mpd_song_feed", dynlib: mpdll.}
proc mpd_recv_song*(connection: ptr mpd_connection): ptr mpd_song {.cdecl,
    importc: "mpd_recv_song", dynlib: mpdll.}
proc mpd_entity_free*(entity: ptr mpd_entity) {.cdecl, importc: "mpd_entity_free",
    dynlib: mpdll.}
proc mpd_entity_get_type*(entity: ptr mpd_entity): mpd_entity_type {.cdecl,
    importc: "mpd_entity_get_type", dynlib: mpdll.}
proc mpd_entity_get_directory*(entity: ptr mpd_entity): ptr mpd_directory {.cdecl,
    importc: "mpd_entity_get_directory", dynlib: mpdll.}
proc mpd_entity_get_song*(entity: ptr mpd_entity): ptr mpd_song {.cdecl,
    importc: "mpd_entity_get_song", dynlib: mpdll.}
proc mpd_entity_get_playlist*(entity: ptr mpd_entity): ptr mpd_playlist {.cdecl,
    importc: "mpd_entity_get_playlist", dynlib: mpdll.}
proc mpd_entity_begin*(pair: ptr mpd_pair): ptr mpd_entity {.cdecl,
    importc: "mpd_entity_begin", dynlib: mpdll.}
proc mpd_entity_feed*(entity: ptr mpd_entity; pair: ptr mpd_pair): bool {.cdecl,
    importc: "mpd_entity_feed", dynlib: mpdll.}
proc mpd_recv_entity*(connection: ptr mpd_connection): ptr mpd_entity {.cdecl,
    importc: "mpd_recv_entity", dynlib: mpdll.}
proc mpd_idle_name*(idle: mpd_idle): cstring {.cdecl, importc: "mpd_idle_name",
    dynlib: mpdll.}
proc mpd_idle_name_parse*(name: cstring): mpd_idle {.cdecl,
    importc: "mpd_idle_name_parse", dynlib: mpdll.}
proc mpd_send_idle*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_idle", dynlib: mpdll.}
proc mpd_send_idle_mask*(connection: ptr mpd_connection; mask: mpd_idle): bool {.cdecl,
    importc: "mpd_send_idle_mask", dynlib: mpdll.}
proc mpd_send_noidle*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_noidle", dynlib: mpdll.}
proc mpd_idle_parse_pair*(pair: ptr mpd_pair): mpd_idle {.cdecl,
    importc: "mpd_idle_parse_pair", dynlib: mpdll.}
proc mpd_recv_idle*(connection: ptr mpd_connection; disable_timeout: bool): mpd_idle {.
    cdecl, importc: "mpd_recv_idle", dynlib: mpdll.}
proc mpd_run_idle*(connection: ptr mpd_connection): mpd_idle {.cdecl,
    importc: "mpd_run_idle", dynlib: mpdll.}
proc mpd_run_idle_mask*(connection: ptr mpd_connection; mask: mpd_idle): mpd_idle {.
    cdecl, importc: "mpd_run_idle_mask", dynlib: mpdll.}
proc mpd_run_noidle*(connection: ptr mpd_connection): mpd_idle {.cdecl,
    importc: "mpd_run_noidle", dynlib: mpdll.}
proc mpd_command_list_begin*(connection: ptr mpd_connection; discrete_ok: bool): bool {.
    cdecl, importc: "mpd_command_list_begin", dynlib: mpdll.}
proc mpd_command_list_end*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_command_list_end", dynlib: mpdll.}
type
  mpd_message* = object


proc mpd_message_begin*(pair: ptr mpd_pair): ptr mpd_message {.cdecl,
    importc: "mpd_message_begin", dynlib: mpdll.}
proc mpd_message_feed*(output: ptr mpd_message; pair: ptr mpd_pair): bool {.cdecl,
    importc: "mpd_message_feed", dynlib: mpdll.}
proc mpd_message_free*(message: ptr mpd_message) {.cdecl,
    importc: "mpd_message_free", dynlib: mpdll.}
proc mpd_message_get_channel*(message: ptr mpd_message): cstring {.cdecl,
    importc: "mpd_message_get_channel", dynlib: mpdll.}
proc mpd_message_get_text*(message: ptr mpd_message): cstring {.cdecl,
    importc: "mpd_message_get_text", dynlib: mpdll.}
proc mpd_send_subscribe*(connection: ptr mpd_connection; channel: cstring): bool {.
    cdecl, importc: "mpd_send_subscribe", dynlib: mpdll.}
proc mpd_run_subscribe*(connection: ptr mpd_connection; channel: cstring): bool {.
    cdecl, importc: "mpd_run_subscribe", dynlib: mpdll.}
proc mpd_send_unsubscribe*(connection: ptr mpd_connection; channel: cstring): bool {.
    cdecl, importc: "mpd_send_unsubscribe", dynlib: mpdll.}
proc mpd_run_unsubscribe*(connection: ptr mpd_connection; channel: cstring): bool {.
    cdecl, importc: "mpd_run_unsubscribe", dynlib: mpdll.}
proc mpd_send_send_message*(connection: ptr mpd_connection; channel: cstring;
                           text: cstring): bool {.cdecl,
    importc: "mpd_send_send_message", dynlib: mpdll.}
proc mpd_run_send_message*(connection: ptr mpd_connection; channel: cstring;
                          text: cstring): bool {.cdecl,
    importc: "mpd_run_send_message", dynlib: mpdll.}
proc mpd_send_read_messages*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_read_messages", dynlib: mpdll.}
proc mpd_recv_message*(connection: ptr mpd_connection): ptr mpd_message {.cdecl,
    importc: "mpd_recv_message", dynlib: mpdll.}
proc mpd_send_channels*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_channels", dynlib: mpdll.}
proc mpd_recv_channel_pair*(connection: ptr mpd_connection): ptr mpd_pair {.inline,
    cdecl.} =
  return mpd_recv_pair_named(connection, "channel")

proc mpd_send_set_volume*(connection: ptr mpd_connection; volume: cuint): bool {.cdecl,
    importc: "mpd_send_set_volume", dynlib: mpdll.}
proc mpd_run_set_volume*(connection: ptr mpd_connection; volume: cuint): bool {.cdecl,
    importc: "mpd_run_set_volume", dynlib: mpdll.}
proc mpd_send_change_volume*(connection: ptr mpd_connection; relative_volume: cint): bool {.
    cdecl, importc: "mpd_send_change_volume", dynlib: mpdll.}
proc mpd_run_change_volume*(connection: ptr mpd_connection; relative_volume: cint): bool {.
    cdecl, importc: "mpd_run_change_volume", dynlib: mpdll.}
type
  mpd_output* = object


proc mpd_output_begin*(pair: ptr mpd_pair): ptr mpd_output {.cdecl,
    importc: "mpd_output_begin", dynlib: mpdll.}
proc mpd_output_feed*(output: ptr mpd_output; pair: ptr mpd_pair): bool {.cdecl,
    importc: "mpd_output_feed", dynlib: mpdll.}
proc mpd_output_free*(output: ptr mpd_output) {.cdecl, importc: "mpd_output_free",
    dynlib: mpdll.}
proc mpd_output_get_id*(output: ptr mpd_output): cuint {.cdecl,
    importc: "mpd_output_get_id", dynlib: mpdll.}
proc mpd_output_get_name*(output: ptr mpd_output): cstring {.cdecl,
    importc: "mpd_output_get_name", dynlib: mpdll.}
proc mpd_output_get_enabled*(output: ptr mpd_output): bool {.cdecl,
    importc: "mpd_output_get_enabled", dynlib: mpdll.}
proc mpd_send_outputs*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_outputs", dynlib: mpdll.}
proc mpd_recv_output*(connection: ptr mpd_connection): ptr mpd_output {.cdecl,
    importc: "mpd_recv_output", dynlib: mpdll.}
proc mpd_send_enable_output*(connection: ptr mpd_connection; output_id: cuint): bool {.
    cdecl, importc: "mpd_send_enable_output", dynlib: mpdll.}
proc mpd_run_enable_output*(connection: ptr mpd_connection; output_id: cuint): bool {.
    cdecl, importc: "mpd_run_enable_output", dynlib: mpdll.}
proc mpd_send_disable_output*(connection: ptr mpd_connection; output_id: cuint): bool {.
    cdecl, importc: "mpd_send_disable_output", dynlib: mpdll.}
proc mpd_run_disable_output*(connection: ptr mpd_connection; output_id: cuint): bool {.
    cdecl, importc: "mpd_run_disable_output", dynlib: mpdll.}
proc mpd_send_toggle_output*(connection: ptr mpd_connection; output_id: cuint): bool {.
    cdecl, importc: "mpd_send_toggle_output", dynlib: mpdll.}
proc mpd_run_toggle_output*(connection: ptr mpd_connection; output_id: cuint): bool {.
    cdecl, importc: "mpd_run_toggle_output", dynlib: mpdll.}
proc mpd_send_password*(connection: ptr mpd_connection; password: cstring): bool {.
    cdecl, importc: "mpd_send_password", dynlib: mpdll.}
proc mpd_run_password*(connection: ptr mpd_connection; password: cstring): bool {.
    cdecl, importc: "mpd_run_password", dynlib: mpdll.}
proc mpd_send_current_song*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_current_song", dynlib: mpdll.}
proc mpd_run_current_song*(connection: ptr mpd_connection): ptr mpd_song {.cdecl,
    importc: "mpd_run_current_song", dynlib: mpdll.}
proc mpd_send_play*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_play", dynlib: mpdll.}
proc mpd_run_play*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_run_play", dynlib: mpdll.}
proc mpd_send_play_pos*(connection: ptr mpd_connection; song_pos: cuint): bool {.cdecl,
    importc: "mpd_send_play_pos", dynlib: mpdll.}
proc mpd_run_play_pos*(connection: ptr mpd_connection; song_pos: cuint): bool {.cdecl,
    importc: "mpd_run_play_pos", dynlib: mpdll.}
proc mpd_send_play_id*(connection: ptr mpd_connection; id: cuint): bool {.cdecl,
    importc: "mpd_send_play_id", dynlib: mpdll.}
proc mpd_run_play_id*(connection: ptr mpd_connection; song_id: cuint): bool {.cdecl,
    importc: "mpd_run_play_id", dynlib: mpdll.}
proc mpd_send_stop*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_stop", dynlib: mpdll.}
proc mpd_run_stop*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_run_stop", dynlib: mpdll.}
proc mpd_send_toggle_pause*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_toggle_pause", dynlib: mpdll.}
proc mpd_run_toggle_pause*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_run_toggle_pause", dynlib: mpdll.}
proc mpd_send_pause*(connection: ptr mpd_connection; mode: bool): bool {.cdecl,
    importc: "mpd_send_pause", dynlib: mpdll.}
proc mpd_run_pause*(connection: ptr mpd_connection; mode: bool): bool {.cdecl,
    importc: "mpd_run_pause", dynlib: mpdll.}
proc mpd_send_next*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_next", dynlib: mpdll.}
proc mpd_run_next*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_run_next", dynlib: mpdll.}
proc mpd_send_previous*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_previous", dynlib: mpdll.}
proc mpd_run_previous*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_run_previous", dynlib: mpdll.}
proc mpd_send_seek_pos*(connection: ptr mpd_connection; song_pos: cuint; t: cuint): bool {.
    cdecl, importc: "mpd_send_seek_pos", dynlib: mpdll.}
proc mpd_run_seek_pos*(connection: ptr mpd_connection; song_pos: cuint; t: cuint): bool {.
    cdecl, importc: "mpd_run_seek_pos", dynlib: mpdll.}
proc mpd_send_seek_id*(connection: ptr mpd_connection; id: cuint; t: cuint): bool {.
    cdecl, importc: "mpd_send_seek_id", dynlib: mpdll.}
proc mpd_run_seek_id*(connection: ptr mpd_connection; song_id: cuint; t: cuint): bool {.
    cdecl, importc: "mpd_run_seek_id", dynlib: mpdll.}
proc mpd_send_repeat*(connection: ptr mpd_connection; mode: bool): bool {.cdecl,
    importc: "mpd_send_repeat", dynlib: mpdll.}
proc mpd_run_repeat*(connection: ptr mpd_connection; mode: bool): bool {.cdecl,
    importc: "mpd_run_repeat", dynlib: mpdll.}
proc mpd_send_random*(connection: ptr mpd_connection; mode: bool): bool {.cdecl,
    importc: "mpd_send_random", dynlib: mpdll.}
proc mpd_run_random*(connection: ptr mpd_connection; mode: bool): bool {.cdecl,
    importc: "mpd_run_random", dynlib: mpdll.}
proc mpd_send_single*(connection: ptr mpd_connection; mode: bool): bool {.cdecl,
    importc: "mpd_send_single", dynlib: mpdll.}
proc mpd_run_single*(connection: ptr mpd_connection; mode: bool): bool {.cdecl,
    importc: "mpd_run_single", dynlib: mpdll.}
proc mpd_send_consume*(connection: ptr mpd_connection; mode: bool): bool {.cdecl,
    importc: "mpd_send_consume", dynlib: mpdll.}
proc mpd_run_consume*(connection: ptr mpd_connection; mode: bool): bool {.cdecl,
    importc: "mpd_run_consume", dynlib: mpdll.}
proc mpd_send_crossfade*(connection: ptr mpd_connection; seconds: cuint): bool {.cdecl,
    importc: "mpd_send_crossfade", dynlib: mpdll.}
proc mpd_run_crossfade*(connection: ptr mpd_connection; seconds: cuint): bool {.cdecl,
    importc: "mpd_run_crossfade", dynlib: mpdll.}
proc mpd_send_mixrampdb*(connection: ptr mpd_connection; db: cfloat): bool {.cdecl,
    importc: "mpd_send_mixrampdb", dynlib: mpdll.}
proc mpd_run_mixrampdb*(connection: ptr mpd_connection; db: cfloat): bool {.cdecl,
    importc: "mpd_run_mixrampdb", dynlib: mpdll.}
proc mpd_send_mixrampdelay*(connection: ptr mpd_connection; seconds: cfloat): bool {.
    cdecl, importc: "mpd_send_mixrampdelay", dynlib: mpdll.}
proc mpd_run_mixrampdelay*(connection: ptr mpd_connection; seconds: cfloat): bool {.
    cdecl, importc: "mpd_run_mixrampdelay", dynlib: mpdll.}
proc mpd_send_clearerror*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_clearerror", dynlib: mpdll.}
proc mpd_run_clearerror*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_run_clearerror", dynlib: mpdll.}
proc mpd_playlist_free*(playlist: ptr mpd_playlist) {.cdecl,
    importc: "mpd_playlist_free", dynlib: mpdll.}
proc mpd_playlist_dup*(playlist: ptr mpd_playlist): ptr mpd_playlist {.cdecl,
    importc: "mpd_playlist_dup", dynlib: mpdll.}
proc mpd_playlist_get_path*(playlist: ptr mpd_playlist): cstring {.cdecl,
    importc: "mpd_playlist_get_path", dynlib: mpdll.}
proc mpd_playlist_get_last_modified*(playlist: ptr mpd_playlist): Time {.cdecl,
    importc: "mpd_playlist_get_last_modified", dynlib: mpdll.}
proc mpd_playlist_begin*(pair: ptr mpd_pair): ptr mpd_playlist {.cdecl,
    importc: "mpd_playlist_begin", dynlib: mpdll.}
proc mpd_playlist_feed*(playlist: ptr mpd_playlist; pair: ptr mpd_pair): bool {.cdecl,
    importc: "mpd_playlist_feed", dynlib: mpdll.}
proc mpd_send_list_playlists*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_list_playlists", dynlib: mpdll.}
proc mpd_recv_playlist*(connection: ptr mpd_connection): ptr mpd_playlist {.cdecl,
    importc: "mpd_recv_playlist", dynlib: mpdll.}
proc mpd_send_list_playlist*(connection: ptr mpd_connection; name: cstring): bool {.
    cdecl, importc: "mpd_send_list_playlist", dynlib: mpdll.}
proc mpd_send_list_playlist_meta*(connection: ptr mpd_connection; name: cstring): bool {.
    cdecl, importc: "mpd_send_list_playlist_meta", dynlib: mpdll.}
proc mpd_send_playlist_clear*(connection: ptr mpd_connection; name: cstring): bool {.
    cdecl, importc: "mpd_send_playlist_clear", dynlib: mpdll.}
proc mpd_run_playlist_clear*(connection: ptr mpd_connection; name: cstring): bool {.
    cdecl, importc: "mpd_run_playlist_clear", dynlib: mpdll.}
proc mpd_send_playlist_add*(connection: ptr mpd_connection; name: cstring;
                           path: cstring): bool {.cdecl,
    importc: "mpd_send_playlist_add", dynlib: mpdll.}
proc mpd_run_playlist_add*(connection: ptr mpd_connection; name: cstring;
                          path: cstring): bool {.cdecl,
    importc: "mpd_run_playlist_add", dynlib: mpdll.}
proc mpd_send_playlist_move*(connection: ptr mpd_connection; name: cstring;
                            `from`: cuint; to: cuint): bool {.cdecl,
    importc: "mpd_send_playlist_move", dynlib: mpdll.}
proc mpd_send_playlist_delete*(connection: ptr mpd_connection; name: cstring;
                              pos: cuint): bool {.cdecl,
    importc: "mpd_send_playlist_delete", dynlib: mpdll.}
proc mpd_run_playlist_delete*(connection: ptr mpd_connection; name: cstring;
                             pos: cuint): bool {.cdecl,
    importc: "mpd_run_playlist_delete", dynlib: mpdll.}
proc mpd_send_save*(connection: ptr mpd_connection; name: cstring): bool {.cdecl,
    importc: "mpd_send_save", dynlib: mpdll.}
proc mpd_run_save*(connection: ptr mpd_connection; name: cstring): bool {.cdecl,
    importc: "mpd_run_save", dynlib: mpdll.}
proc mpd_send_load*(connection: ptr mpd_connection; name: cstring): bool {.cdecl,
    importc: "mpd_send_load", dynlib: mpdll.}
proc mpd_run_load*(connection: ptr mpd_connection; name: cstring): bool {.cdecl,
    importc: "mpd_run_load", dynlib: mpdll.}
proc mpd_send_rename*(connection: ptr mpd_connection; `from`: cstring; to: cstring): bool {.
    cdecl, importc: "mpd_send_rename", dynlib: mpdll.}
proc mpd_run_rename*(connection: ptr mpd_connection; `from`: cstring; to: cstring): bool {.
    cdecl, importc: "mpd_run_rename", dynlib: mpdll.}
proc mpd_send_rm*(connection: ptr mpd_connection; name: cstring): bool {.cdecl,
    importc: "mpd_send_rm", dynlib: mpdll.}
proc mpd_run_rm*(connection: ptr mpd_connection; name: cstring): bool {.cdecl,
    importc: "mpd_run_rm", dynlib: mpdll.}
proc mpd_send_list_queue_meta*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_list_queue_meta", dynlib: mpdll.}
proc mpd_send_list_queue_range_meta*(connection: ptr mpd_connection; start: cuint;
                                    `end`: cuint): bool {.cdecl,
    importc: "mpd_send_list_queue_range_meta", dynlib: mpdll.}
proc mpd_send_get_queue_song_pos*(connection: ptr mpd_connection; pos: cuint): bool {.
    cdecl, importc: "mpd_send_get_queue_song_pos", dynlib: mpdll.}
proc mpd_run_get_queue_song_pos*(connection: ptr mpd_connection; pos: cuint): ptr mpd_song {.
    cdecl, importc: "mpd_run_get_queue_song_pos", dynlib: mpdll.}
proc mpd_send_get_queue_song_id*(connection: ptr mpd_connection; id: cuint): bool {.
    cdecl, importc: "mpd_send_get_queue_song_id", dynlib: mpdll.}
proc mpd_run_get_queue_song_id*(connection: ptr mpd_connection; id: cuint): ptr mpd_song {.
    cdecl, importc: "mpd_run_get_queue_song_id", dynlib: mpdll.}
proc mpd_send_queue_changes_meta*(connection: ptr mpd_connection; version: cuint): bool {.
    cdecl, importc: "mpd_send_queue_changes_meta", dynlib: mpdll.}
proc mpd_send_queue_changes_brief*(connection: ptr mpd_connection; version: cuint): bool {.
    cdecl, importc: "mpd_send_queue_changes_brief", dynlib: mpdll.}
proc mpd_recv_queue_change_brief*(connection: ptr mpd_connection;
                                 position_r: ptr cuint; id_r: ptr cuint): bool {.cdecl,
    importc: "mpd_recv_queue_change_brief", dynlib: mpdll.}
proc mpd_send_add*(connection: ptr mpd_connection; file: cstring): bool {.cdecl,
    importc: "mpd_send_add", dynlib: mpdll.}
proc mpd_run_add*(connection: ptr mpd_connection; uri: cstring): bool {.cdecl,
    importc: "mpd_run_add", dynlib: mpdll.}
proc mpd_send_add_id*(connection: ptr mpd_connection; file: cstring): bool {.cdecl,
    importc: "mpd_send_add_id", dynlib: mpdll.}
proc mpd_send_add_id_to*(connection: ptr mpd_connection; uri: cstring; to: cuint): bool {.
    cdecl, importc: "mpd_send_add_id_to", dynlib: mpdll.}
proc mpd_recv_song_id*(connection: ptr mpd_connection): cint {.cdecl,
    importc: "mpd_recv_song_id", dynlib: mpdll.}
proc mpd_run_add_id*(connection: ptr mpd_connection; file: cstring): cint {.cdecl,
    importc: "mpd_run_add_id", dynlib: mpdll.}
proc mpd_run_add_id_to*(connection: ptr mpd_connection; uri: cstring; to: cuint): cint {.
    cdecl, importc: "mpd_run_add_id_to", dynlib: mpdll.}
proc mpd_send_delete*(connection: ptr mpd_connection; pos: cuint): bool {.cdecl,
    importc: "mpd_send_delete", dynlib: mpdll.}
proc mpd_run_delete*(connection: ptr mpd_connection; pos: cuint): bool {.cdecl,
    importc: "mpd_run_delete", dynlib: mpdll.}
proc mpd_send_delete_range*(connection: ptr mpd_connection; start: cuint; `end`: cuint): bool {.
    cdecl, importc: "mpd_send_delete_range", dynlib: mpdll.}
proc mpd_run_delete_range*(connection: ptr mpd_connection; start: cuint; `end`: cuint): bool {.
    cdecl, importc: "mpd_run_delete_range", dynlib: mpdll.}
proc mpd_send_delete_id*(connection: ptr mpd_connection; id: cuint): bool {.cdecl,
    importc: "mpd_send_delete_id", dynlib: mpdll.}
proc mpd_run_delete_id*(connection: ptr mpd_connection; id: cuint): bool {.cdecl,
    importc: "mpd_run_delete_id", dynlib: mpdll.}
proc mpd_send_shuffle*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_shuffle", dynlib: mpdll.}
proc mpd_run_shuffle*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_run_shuffle", dynlib: mpdll.}
proc mpd_send_shuffle_range*(connection: ptr mpd_connection; start: cuint;
                            `end`: cuint): bool {.cdecl,
    importc: "mpd_send_shuffle_range", dynlib: mpdll.}
proc mpd_run_shuffle_range*(connection: ptr mpd_connection; start: cuint; `end`: cuint): bool {.
    cdecl, importc: "mpd_run_shuffle_range", dynlib: mpdll.}
proc mpd_send_clear*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_clear", dynlib: mpdll.}
proc mpd_run_clear*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_run_clear", dynlib: mpdll.}
proc mpd_send_move*(connection: ptr mpd_connection; `from`: cuint; to: cuint): bool {.
    cdecl, importc: "mpd_send_move", dynlib: mpdll.}
proc mpd_run_move*(connection: ptr mpd_connection; `from`: cuint; to: cuint): bool {.
    cdecl, importc: "mpd_run_move", dynlib: mpdll.}
proc mpd_send_move_id*(connection: ptr mpd_connection; `from`: cuint; to: cuint): bool {.
    cdecl, importc: "mpd_send_move_id", dynlib: mpdll.}
proc mpd_run_move_id*(connection: ptr mpd_connection; `from`: cuint; to: cuint): bool {.
    cdecl, importc: "mpd_run_move_id", dynlib: mpdll.}
proc mpd_send_move_range*(connection: ptr mpd_connection; start: cuint; `end`: cuint;
                         to: cuint): bool {.cdecl, importc: "mpd_send_move_range",
    dynlib: mpdll.}
proc mpd_run_move_range*(connection: ptr mpd_connection; start: cuint; `end`: cuint;
                        to: cuint): bool {.cdecl, importc: "mpd_run_move_range",
                                        dynlib: mpdll.}
proc mpd_send_swap*(connection: ptr mpd_connection; pos1: cuint; pos2: cuint): bool {.
    cdecl, importc: "mpd_send_swap", dynlib: mpdll.}
proc mpd_run_swap*(connection: ptr mpd_connection; pos1: cuint; pos2: cuint): bool {.
    cdecl, importc: "mpd_run_swap", dynlib: mpdll.}
proc mpd_send_swap_id*(connection: ptr mpd_connection; id1: cuint; id2: cuint): bool {.
    cdecl, importc: "mpd_send_swap_id", dynlib: mpdll.}
proc mpd_run_swap_id*(connection: ptr mpd_connection; id1: cuint; id2: cuint): bool {.
    cdecl, importc: "mpd_run_swap_id", dynlib: mpdll.}
proc mpd_send_prio*(connection: ptr mpd_connection; priority: cint; position: cuint): bool {.
    cdecl, importc: "mpd_send_prio", dynlib: mpdll.}
proc mpd_run_prio*(connection: ptr mpd_connection; priority: cint; position: cuint): bool {.
    cdecl, importc: "mpd_run_prio", dynlib: mpdll.}
proc mpd_send_prio_range*(connection: ptr mpd_connection; priority: cint;
                         start: cuint; `end`: cuint): bool {.cdecl,
    importc: "mpd_send_prio_range", dynlib: mpdll.}
proc mpd_run_prio_range*(connection: ptr mpd_connection; priority: cint; start: cuint;
                        `end`: cuint): bool {.cdecl, importc: "mpd_run_prio_range",
    dynlib: mpdll.}
proc mpd_send_prio_id*(connection: ptr mpd_connection; priority: cint; id: cuint): bool {.
    cdecl, importc: "mpd_send_prio_id", dynlib: mpdll.}
proc mpd_run_prio_id*(connection: ptr mpd_connection; priority: cint; id: cuint): bool {.
    cdecl, importc: "mpd_run_prio_id", dynlib: mpdll.}
proc mpd_response_finish*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_response_finish", dynlib: mpdll.}
proc mpd_response_next*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_response_next", dynlib: mpdll.}
proc mpd_search_db_songs*(connection: ptr mpd_connection; exact: bool): bool {.cdecl,
    importc: "mpd_search_db_songs", dynlib: mpdll.}
proc mpd_search_add_db_songs*(connection: ptr mpd_connection; exact: bool): bool {.
    cdecl, importc: "mpd_search_add_db_songs", dynlib: mpdll.}
proc mpd_search_queue_songs*(connection: ptr mpd_connection; exact: bool): bool {.
    cdecl, importc: "mpd_search_queue_songs", dynlib: mpdll.}
proc mpd_search_db_tags*(connection: ptr mpd_connection; `type`: mpd_tag_type): bool {.
    cdecl, importc: "mpd_search_db_tags", dynlib: mpdll.}
proc mpd_count_db_songs*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_count_db_songs", dynlib: mpdll.}
proc mpd_search_add_base_constraint*(connection: ptr mpd_connection;
                                    oper: mpd_operator; value: cstring): bool {.
    cdecl, importc: "mpd_search_add_base_constraint", dynlib: mpdll.}
proc mpd_search_add_uri_constraint*(connection: ptr mpd_connection;
                                   oper: mpd_operator; value: cstring): bool {.cdecl,
    importc: "mpd_search_add_uri_constraint", dynlib: mpdll.}
proc mpd_search_add_tag_constraint*(connection: ptr mpd_connection;
                                   oper: mpd_operator; `type`: mpd_tag_type;
                                   value: cstring): bool {.cdecl,
    importc: "mpd_search_add_tag_constraint", dynlib: mpdll.}
proc mpd_search_add_any_tag_constraint*(connection: ptr mpd_connection;
                                       oper: mpd_operator; value: cstring): bool {.
    cdecl, importc: "mpd_search_add_any_tag_constraint", dynlib: mpdll.}
proc mpd_search_add_modified_since_constraint*(connection: ptr mpd_connection;
    oper: mpd_operator; value: Time): bool {.cdecl, importc: "mpd_search_add_modified_since_constraint",
                                        dynlib: mpdll.}
proc mpd_search_add_window*(connection: ptr mpd_connection; start: cuint; `end`: cuint): bool {.
    cdecl, importc: "mpd_search_add_window", dynlib: mpdll.}
proc mpd_search_commit*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_search_commit", dynlib: mpdll.}
proc mpd_search_cancel*(connection: ptr mpd_connection) {.cdecl,
    importc: "mpd_search_cancel", dynlib: mpdll.}
proc mpd_recv_pair_tag*(connection: ptr mpd_connection; `type`: mpd_tag_type): ptr mpd_pair {.
    cdecl, importc: "mpd_recv_pair_tag", dynlib: mpdll.}
proc mpd_send_command*(connection: ptr mpd_connection; command: cstring): bool {.
    varargs, cdecl, importc: "mpd_send_command", dynlib: mpdll.}
proc mpd_settings_new*(host: cstring; port: cuint; timeout_ms: cuint;
                      reserved: cstring; password: cstring): ptr mpd_settings {.cdecl,
    importc: "mpd_settings_new", dynlib: mpdll.}
proc mpd_settings_free*(settings: ptr mpd_settings) {.cdecl,
    importc: "mpd_settings_free", dynlib: mpdll.}
proc mpd_settings_get_host*(settings: ptr mpd_settings): cstring {.cdecl,
    importc: "mpd_settings_get_host", dynlib: mpdll.}
proc mpd_settings_get_port*(settings: ptr mpd_settings): cuint {.cdecl,
    importc: "mpd_settings_get_port", dynlib: mpdll.}
proc mpd_settings_get_timeout_ms*(settings: ptr mpd_settings): cuint {.cdecl,
    importc: "mpd_settings_get_timeout_ms", dynlib: mpdll.}
proc mpd_settings_get_password*(settings: ptr mpd_settings): cstring {.cdecl,
    importc: "mpd_settings_get_password", dynlib: mpdll.}
proc mpd_send_stats*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_stats", dynlib: mpdll.}
proc mpd_stats_begin*(): ptr mpd_stats {.cdecl, importc: "mpd_stats_begin",
                                     dynlib: mpdll.}
proc mpd_stats_feed*(status: ptr mpd_stats; pair: ptr mpd_pair) {.cdecl,
    importc: "mpd_stats_feed", dynlib: mpdll.}
proc mpd_recv_stats*(connection: ptr mpd_connection): ptr mpd_stats {.cdecl,
    importc: "mpd_recv_stats", dynlib: mpdll.}
proc mpd_run_stats*(connection: ptr mpd_connection): ptr mpd_stats {.cdecl,
    importc: "mpd_run_stats", dynlib: mpdll.}
proc mpd_stats_free*(stats: ptr mpd_stats) {.cdecl, importc: "mpd_stats_free",
    dynlib: mpdll.}
proc mpd_stats_get_number_of_artists*(stats: ptr mpd_stats): cuint {.cdecl,
    importc: "mpd_stats_get_number_of_artists", dynlib: mpdll.}
proc mpd_stats_get_number_of_albums*(stats: ptr mpd_stats): cuint {.cdecl,
    importc: "mpd_stats_get_number_of_albums", dynlib: mpdll.}
proc mpd_stats_get_number_of_songs*(stats: ptr mpd_stats): cuint {.cdecl,
    importc: "mpd_stats_get_number_of_songs", dynlib: mpdll.}
proc mpd_stats_get_uptime*(stats: ptr mpd_stats): culong {.cdecl,
    importc: "mpd_stats_get_uptime", dynlib: mpdll.}
proc mpd_stats_get_db_update_time*(stats: ptr mpd_stats): culong {.cdecl,
    importc: "mpd_stats_get_db_update_time", dynlib: mpdll.}
proc mpd_stats_get_play_time*(stats: ptr mpd_stats): culong {.cdecl,
    importc: "mpd_stats_get_play_time", dynlib: mpdll.}
proc mpd_stats_get_db_play_time*(stats: ptr mpd_stats): culong {.cdecl,
    importc: "mpd_stats_get_db_play_time", dynlib: mpdll.}
proc mpd_status_begin*(): ptr mpd_status {.cdecl, importc: "mpd_status_begin",
                                       dynlib: mpdll.}
proc mpd_status_feed*(status: ptr mpd_status; pair: ptr mpd_pair) {.cdecl,
    importc: "mpd_status_feed", dynlib: mpdll.}
proc mpd_send_status*(connection: ptr mpd_connection): bool {.cdecl,
    importc: "mpd_send_status", dynlib: mpdll.}
proc mpd_recv_status*(connection: ptr mpd_connection): ptr mpd_status {.cdecl,
    importc: "mpd_recv_status", dynlib: mpdll.}
proc mpd_run_status*(connection: ptr mpd_connection): ptr mpd_status {.cdecl,
    importc: "mpd_run_status", dynlib: mpdll.}
proc mpd_status_free*(status: ptr mpd_status) {.cdecl, importc: "mpd_status_free",
    dynlib: mpdll.}
proc mpd_status_get_volume*(status: ptr mpd_status): cint {.cdecl,
    importc: "mpd_status_get_volume", dynlib: mpdll.}
proc mpd_status_get_repeat*(status: ptr mpd_status): bool {.cdecl,
    importc: "mpd_status_get_repeat", dynlib: mpdll.}
proc mpd_status_get_random*(status: ptr mpd_status): bool {.cdecl,
    importc: "mpd_status_get_random", dynlib: mpdll.}
proc mpd_status_get_single*(status: ptr mpd_status): bool {.cdecl,
    importc: "mpd_status_get_single", dynlib: mpdll.}
proc mpd_status_get_consume*(status: ptr mpd_status): bool {.cdecl,
    importc: "mpd_status_get_consume", dynlib: mpdll.}
proc mpd_status_get_queue_length*(status: ptr mpd_status): cuint {.cdecl,
    importc: "mpd_status_get_queue_length", dynlib: mpdll.}
proc mpd_status_get_queue_version*(status: ptr mpd_status): cuint {.cdecl,
    importc: "mpd_status_get_queue_version", dynlib: mpdll.}
proc mpd_status_get_state*(status: ptr mpd_status): mpd_state {.cdecl,
    importc: "mpd_status_get_state", dynlib: mpdll.}
proc mpd_status_get_crossfade*(status: ptr mpd_status): cuint {.cdecl,
    importc: "mpd_status_get_crossfade", dynlib: mpdll.}
proc mpd_status_get_mixrampdb*(status: ptr mpd_status): cfloat {.cdecl,
    importc: "mpd_status_get_mixrampdb", dynlib: mpdll.}
proc mpd_status_get_mixrampdelay*(status: ptr mpd_status): cfloat {.cdecl,
    importc: "mpd_status_get_mixrampdelay", dynlib: mpdll.}
proc mpd_status_get_song_pos*(status: ptr mpd_status): cint {.cdecl,
    importc: "mpd_status_get_song_pos", dynlib: mpdll.}
proc mpd_status_get_song_id*(status: ptr mpd_status): cint {.cdecl,
    importc: "mpd_status_get_song_id", dynlib: mpdll.}
proc mpd_status_get_next_song_pos*(status: ptr mpd_status): cint {.cdecl,
    importc: "mpd_status_get_next_song_pos", dynlib: mpdll.}
proc mpd_status_get_next_song_id*(status: ptr mpd_status): cint {.cdecl,
    importc: "mpd_status_get_next_song_id", dynlib: mpdll.}
proc mpd_status_get_elapsed_time*(status: ptr mpd_status): cuint {.cdecl,
    importc: "mpd_status_get_elapsed_time", dynlib: mpdll.}
proc mpd_status_get_elapsed_ms*(status: ptr mpd_status): cuint {.cdecl,
    importc: "mpd_status_get_elapsed_ms", dynlib: mpdll.}
proc mpd_status_get_total_time*(status: ptr mpd_status): cuint {.cdecl,
    importc: "mpd_status_get_total_time", dynlib: mpdll.}
proc mpd_status_get_kbit_rate*(status: ptr mpd_status): cuint {.cdecl,
    importc: "mpd_status_get_kbit_rate", dynlib: mpdll.}
proc mpd_status_get_audio_format*(status: ptr mpd_status): ptr mpd_audio_format {.
    cdecl, importc: "mpd_status_get_audio_format", dynlib: mpdll.}
proc mpd_status_get_update_id*(status: ptr mpd_status): cuint {.cdecl,
    importc: "mpd_status_get_update_id", dynlib: mpdll.}
proc mpd_status_get_error*(status: ptr mpd_status): cstring {.cdecl,
    importc: "mpd_status_get_error", dynlib: mpdll.}
proc mpd_send_sticker_set*(connection: ptr mpd_connection; `type`: cstring;
                          uri: cstring; name: cstring; value: cstring): bool {.cdecl,
    importc: "mpd_send_sticker_set", dynlib: mpdll.}
proc mpd_run_sticker_set*(connection: ptr mpd_connection; `type`: cstring;
                         uri: cstring; name: cstring; value: cstring): bool {.cdecl,
    importc: "mpd_run_sticker_set", dynlib: mpdll.}
proc mpd_send_sticker_delete*(connection: ptr mpd_connection; `type`: cstring;
                             uri: cstring; name: cstring): bool {.cdecl,
    importc: "mpd_send_sticker_delete", dynlib: mpdll.}
proc mpd_run_sticker_delete*(connection: ptr mpd_connection; `type`: cstring;
                            uri: cstring; name: cstring): bool {.cdecl,
    importc: "mpd_run_sticker_delete", dynlib: mpdll.}
proc mpd_send_sticker_get*(connection: ptr mpd_connection; `type`: cstring;
                          uri: cstring; name: cstring): bool {.cdecl,
    importc: "mpd_send_sticker_get", dynlib: mpdll.}
proc mpd_send_sticker_list*(connection: ptr mpd_connection; `type`: cstring;
                           uri: cstring): bool {.cdecl,
    importc: "mpd_send_sticker_list", dynlib: mpdll.}
proc mpd_send_sticker_find*(connection: ptr mpd_connection; `type`: cstring;
                           base_uri: cstring; name: cstring): bool {.cdecl,
    importc: "mpd_send_sticker_find", dynlib: mpdll.}
proc mpd_parse_sticker*(input: cstring; name_length_r: ptr csize): cstring {.cdecl,
    importc: "mpd_parse_sticker", dynlib: mpdll.}
proc mpd_recv_sticker*(connection: ptr mpd_connection): ptr mpd_pair {.cdecl,
    importc: "mpd_recv_sticker", dynlib: mpdll.}
proc mpd_return_sticker*(connection: ptr mpd_connection; pair: ptr mpd_pair) {.cdecl,
    importc: "mpd_return_sticker", dynlib: mpdll.}
