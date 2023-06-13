/// <summary>
/// TableExtension FK GenJournal Line (ID 60065) extends Record Gen. Journal Line.
/// </summary>
tableextension 60065 "FK GenJournal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(60050; "Ref.RV No."; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
}
