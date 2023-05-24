/// <summary>
/// TableExtension FK Item Journal Batch (ID 60060) extends Record Item Journal Batch.
/// </summary>
tableextension 60060 "FK Item Journal Batch" extends "Item Journal Batch"
{
    fields
    {
        field(60050; "Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
    }
}
