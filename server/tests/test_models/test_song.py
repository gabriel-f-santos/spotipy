from src.models import Song


def test_song_model(session):
    # Create a song instance
    song = Song(
        id="song1",
        song_url="http://example.com/song1",
        thumbnail_url="http://example.com/thumb1",
        artist="Artist1",
        song_name="Song1",
        hex_code="FFFFFF",
    )

    # Add song to the session and commit
    session.add(song)
    session.commit()

    # Query the song from the database
    retrieved_song = session.query(Song).filter_by(id="song1").one()

    # Assertions
    assert retrieved_song.id == "song1"
    assert retrieved_song.song_url == "http://example.com/song1"
    assert retrieved_song.thumbnail_url == "http://example.com/thumb1"
    assert retrieved_song.artist == "Artist1"
    assert retrieved_song.song_name == "Song1"
    assert retrieved_song.hex_code == "FFFFFF"
