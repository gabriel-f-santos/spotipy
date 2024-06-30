from src.models import User


def test_user_model(session):
    # Create a user instance
    user = User(
        id="user1",
        name="Test User",
        email="test@example.com",
        password=b"securepassword",
    )

    # Add user to the session and commit
    session.add(user)
    session.commit()

    # Query the user from the database
    retrieved_user = session.query(User).filter_by(id="user1").one()

    # Assertions
    assert retrieved_user.id == "user1"
    assert retrieved_user.name == "Test User"
    assert retrieved_user.email == "test@example.com"
    assert retrieved_user.password == b"securepassword"
