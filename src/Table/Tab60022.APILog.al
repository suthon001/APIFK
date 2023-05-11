/// <summary>
/// Table API Log (ID 60052).
/// </summary>
table 60052 "FK API Log"
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
        field(4; "Json Msg."; Blob)
        {
            Caption = 'Json Msg.';
            DataClassification = CustomerContent;
        }
        field(5; "Response"; Blob)
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
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
        field(9; "Last Error Code"; Text[2047])
        {
            Caption = 'Last Error Code';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(10; "Document No."; Code[100])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(11; "Method Type"; Option)
        {
            Caption = 'Method Type';
            OptionCaption = 'Insert,Update,Delete';
            OptionMembers = "Insert","UpDate","Delete";
            Editable = false;
        }
        field(12; "Interface By"; Code[100])
        {
            Caption = 'Interface By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(13; "Is Manual"; Boolean)
        {
            Caption = 'Is Manual';
            Editable = false;
            DataClassification = CustomerContent;
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
    /// <summary>
    /// GetJsonLog.
    /// </summary>
    /// <returns>Return variable JsonLog of type Text.</returns>
    procedure GetJsonLog() JsonLog: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Json Msg.");
        "Json Msg.".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Json Msg.")));
    end;

    procedure GetResponse() JsonLog: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(Response);
        Response.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName(Response)));
    end;

}
