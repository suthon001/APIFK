table 60058 "Freshket Intregation Setup"
{
    Caption = 'Freshket Intregation Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(2; "FK URL"; Text[1048])
        {
            Caption = 'URL';
            DataClassification = ToBeClassified;
        }
        field(3; "FK UserName"; Text[50])
        {
            Caption = 'UserName';
            DataClassification = ToBeClassified;
        }
        field(4; "FK Password"; Text[100])
        {
            Caption = 'Password';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}
