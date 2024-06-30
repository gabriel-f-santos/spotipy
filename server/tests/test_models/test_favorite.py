from src.models import Favorite, Song, User


def test_favorite_model(session):
    # Create song and user instances
    song = Song(
        id="song1",
        song_url="http://example.com/song1",
        thumbnail_url="http://example.com/thumb1",
        artist="Artist1",
        song_name="Song1",
        hex_code="FFFFFF",
    )
    user = User(
        id="user1",
        name="Test User",
        email="test@example.com",
        password=b"securepassword",
    )

    # Add song and user to the session and commit
    session.add(song)
    session.add(user)
    session.commit()

    # Create favorite instance
    favorite = Favorite(
        id="fav1", song_id=song.id, user_id=user.id, song=song, user=user
    )

    # Add favorite to the session and commit
    session.add(favorite)
    session.commit()

    # Query the favorite from the database
    retrieved_favorite = session.query(Favorite).filter_by(id="fav1").one()

    # Assertions
    assert retrieved_favorite.id == "fav1"
    assert retrieved_favorite.song_id == "song1"
    assert retrieved_favorite.user_id == "user1"
    assert retrieved_favorite.song.song_name == "Song1"
    assert retrieved_favorite.user.name == "Test User"
