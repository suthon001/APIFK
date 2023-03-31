table 50092 "API Log"
{
    Caption = 'API Log';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Date Time"; DateTime)
        {
            Caption = 'Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Json Msg."; Text[2047])
        {
            Caption = 'Json Msg.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Last Error"; Text[2047])
        {
            Caption = 'Last Error';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "Page Name"; Text[50])
        {
            Caption = 'Page Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Successfully,Error';
            OptionMembers = Successfully,Error;
            Editable = false;
        }
        field(8; "No. of API"; Integer)
        {
            Caption = 'No. of API';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(PK2; "No. of API")
        {

        }
        key(PK3; "Page Name", "No. of API")
        {

        }

    }
}
