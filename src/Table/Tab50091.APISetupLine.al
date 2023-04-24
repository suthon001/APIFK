/// <summary>
/// Table API Setup Line (ID 50091).
/// </summary>
table 50091 "API Setup Line"
{
    Caption = 'API Setup Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Page Name"; Enum "FK Api Page Type")
        {
            Caption = 'Page Name';
            DataClassification = CustomerContent;
        }
        field(2; "Line Type"; Option)
        {
            Caption = 'Line Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Field Name"; Text[50])
        {
            Caption = 'Field Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Field Type"; Text[50])
        {
            Caption = 'Field Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "Service Name"; text[50])
        {
            Caption = 'Service Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "Lenth"; text[50])
        {
            Caption = 'Lenth';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(8; "Is Primary"; Boolean)
        {
            Caption = 'Is Primary';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Include"; Boolean)
        {
            Caption = 'Include';
            DataClassification = CustomerContent;
        }
        field(10; Remark; text[2047])
        {
            Caption = 'Remark';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Page Name", "Line Type", "Field No.")
        {
            Clustered = true;
        }
    }
}
